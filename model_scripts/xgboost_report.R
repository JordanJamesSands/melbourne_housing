#---------------------prepare data for xgboost api---------------------------
xgb_train0 <- encode_type(train0) %>% encode_method

#add polar coordinates
MELBOURNE_CENTRE <- c(144.9631,-37.8136)
xgb_train0 <- polarise(MELBOURNE_CENTRE,xgb_train0)

xgb_features <- c(
               'building_area'
              ,'dist_cbd'
              ,'bearing'
              ,'year_built'
              ,'type_encoded'
              ,'nrooms'
              ,'land_area'
              ,'method_encoded'
              ,'nbathroom'
              ,'ncar'
              ,'ntrain_3000'
)

xgb_train0_y <- log(xgb_train0$price)
xgb_train0_x <- xgb_train0 %>% select(xgb_features)

#prepare the data in an xgboost specific data structure
Dtrain0 <- xgb.DMatrix(data=as.matrix(xgb_train0_x),label=xgb_train0_y)

#------------------------ setup parameters--------------------------------------
PARAMS <- list(
    seed=0,
    objective='reg:linear',
    eta=0.005,
    eval_metric='rmse',
    max_depth=7,
    colsample_bytree=0.78,
    subsample=0.80
    
)

#------------------------cross validation---------------------------------------

set.seed(45785)
cv_obj <- xgb.cv(
    params=PARAMS,
    data=Dtrain0,
    nthreads = 4,
    folds=folds,
    verbose=FALSE,
    nrounds=1e+6,
    early_stopping_rounds=2000
    )

#save the number of trees that gives the best out of fold generalisation
OPTIMAL_NROUNDS <- cv_obj$best_ntreelimit

#-----------------------------plot----------------------------------------------

#plot training information
eval_log <- cv_obj$evaluation_log
ggplot(eval_log,aes(x=iter)) + 
  coord_cartesian(ylim=c(0,0.4)) + xlab('iteration') + ylab('score') + 
  ggtitle('Validating Xgboost model') +
  geom_line(aes(y=train_rmse_mean),lwd=1,col='#0078D7') +
  geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
  geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
  geom_line(aes(y=test_rmse_mean),lwd=1,col='orange') +
  geom_line(aes(y=test_rmse_mean + test_rmse_std),lwd=1,col='orange',lty=2) +
  geom_line(aes(y=test_rmse_mean - test_rmse_std),lwd=1,col='orange',lty=2) 

#----------------generate out-of-fold (oof) predictions-------------------------

#initialise the out-of-fold predictions vector
xgb_oof_preds <- rep(NA,nrow(train0))

for (i in 1:KFOLD) {
    fold <- folds[[i]]
    
    #prepare fold specific training data
    train0_x_fold <- xgb_train0_x[-fold,]
    train0_y_fold <- xgb_train0_y[-fold]
    Dtrain0_fold <- xgb.DMatrix(data=as.matrix(train0_x_fold),label=train0_y_fold)
    
    #prepare fold specific validation data
    val0_x_fold <- xgb_train0_x[fold,]
    val0_y_fold <- xgb_train0_y[fold]
    Dval0_fold <- xgb.DMatrix(data=as.matrix(val0_x_fold),label=val0_y_fold)
    
    #fit the model
    model <- xgb.train(params=PARAMS,
                       data=Dtrain0_fold,
                       nrounds=OPTIMAL_NROUNDS,
                       verbose=0)
    
    #save out of fold predictions
    preds <- predict(model,newdata=Dval0_fold)
    xgb_oof_preds[fold] <- preds
}

#compute out of fold error
xgb_oof_error <- sqrt(mean((xgb_oof_preds-xgb_train0_y )^2))

#---------------------- train model on all train0-------------------------------

#Retrain the model on all train0, this will be used to predict on the ensemble
#validation set, the predictions will be used to 
#validate the ensembling meta model
xgb_model <- xgboost(data = as.matrix(xgb_train0_x), 
                     label = xgb_train0_y , 
                     params = PARAMS,
                     verbose=FALSE,
                     nrounds = OPTIMAL_NROUNDS
)

#----------------------------feature importance---------------------------------

#Plot feature importances for this model
xgb_fi <- xgb.importance(model=xgb_model)
xgb.plot.importance(xgb_fi,measure='Gain',main='Feature Importance (gain)')

#----------------create predictions for the ensemble fold-----------------------

#These predictions will be used to validate the ensembling meta model
xgb_ensemble_validation <- encode_type(ensemble_validation) %>% encode_method %>% 
    polarise(MELBOURNE_CENTRE,.)

xgb_ensemble_validation_y <- log(xgb_ensemble_validation$price)
xgb_ensemble_validation_x <- xgb_ensemble_validation %>% 
    select(xgb_features) %>% as.matrix

xgb_ens_preds <- predict(xgb_model,newdata <- xgb_ensemble_validation_x)

################################################################################

#---------train model on train and ensembling data to use for final testing-----
#xgb_train_ens <- rbind(train0,ensemble_validation)
#xgb_train_ens_y <- log(xgb_train_ens$price)
#xgb_train_ens_x <- xgb_train_ens %>% polarise(MELBOURNE_CENTRE,.) %>% select(xgb_features)

#xgb_model_train_ens <- xgboost(data = as.matrix(xgb_train_ens_x), 
#                     label = xgb_train_ens_y, 
#                     params = PARAMS,
#                     verbose=FALSE,
#                     nrounds = OPTIMAL_NROUNDS
#)

#---------create predictions to use as metafeatures for the final test----------
#xgb_test_data <- encode_type(test_data) %>% polarise(MELBOURNE_CENTRE,.)
#xgb_test_x <- xgb_test_data %>% select(xgb_features) %>% as.matrix
#xgb_oof_preds_test <- predict(xgb_model_train_ens,newdata=xgb_test_x)

#---------------------------------------------record for tuning-----------------

#xgb_cv_error <- cv_obj$evaluation_log$test_rmse_mean %>% min
#nam <- names(tune_log_xgb)
#cv_error <- min(cv_obj$evaluation_log$test_rmse_mean)
#tune_log_xgb <- rbind(tune_log_xgb,c((names(for_tune_log_xgb) %in% names(xgb_train0_x))*1,xgb_oof_error,xgb_cv_error))
#names(tune_log_xgb) <- nam
#tune_log_xgb

