#---------------------prepare data for xgboost api---------------------------
xgb_train0 <- encode_type(train0)

#add polar coordinates
MELBOURNE_CENTRE <- c(144.9631,-37.8136)
xgb_train0 <- polarise(MELBOURNE_CENTRE,xgb_train0)

features <- c('building_area'
              ,'lng'
              ,'lat'
              #,'dist_cbd'
              #,'bearing'
              ,'year_built'
              ,'type_encoded'
              ,'nrooms'
              ,'land_area'
              #,'method_encoded'
              ,'nbathroom'
              ,'ncar'
              
              #,'nbar_1000'
              #,'bar_min_dist'
              
              #,'nbbq_1000'
              #,'bbq_min_dist'
              
              #,'ncafe_1000'
              #,'cafe_min_dist'
              
              #,'nkindergarten_2000'
              #,'kindergarten_min_dist'
              
              #,'nschool_2000'
              #,'school_min_dist'
              
              #,'ntrain_3000'
              #,'train_min_dist'
              
              #,'nsupermarket_2000'
              #,'supermarket_min_dist'
)
#row 2 is base (verify later)

#osm to consider (keep in mind, it could just be added complexity)
#nbar 1000
#bar min dist
#nbbq 1000
#bbq min dist
#ncafe_1000
#cafe min dist
#nkinder 2000
#nschool 2000
#'ntrain_3000'
#train min dist
#nsuper 2000
#super min dist

#osm dont consider
#kinder min dist
#school min dist
#
#


xgb_train0_y <- log(xgb_train0$price)
xgb_train0_x <- xgb_train0 %>% select(features)

#prepare the data in an xgboost specific data structure
Dtrain0 <- xgb.DMatrix(data=as.matrix(xgb_train0_x),label=xgb_train0_y)

#------------------------ setup parameters--------------------------------------
PARAMS <- list(
    seed=0,
    objective='reg:linear',
    eta=0.05,
    eval_metric='rmse',
    max_depth=6,
    colsample_bytree=0.8,
    subsample=0.8
    
)

#------------------------cross validation---------------------------------------

#set.seed(457835)
set.seed(45785)
cv_obj <- xgb.cv(
    params=PARAMS,
    data=Dtrain0,
    nthreads = 18,
    folds=folds,
    verbose=FALSE,
    nrounds=1e+6,
    early_stopping_rounds=200
)

#save the number of trees that gives the best out of fold generalisation
OPTIMAL_NROUNDS <- cv_obj$best_ntreelimit

#-----------------------------plot----------------------------------------------

#plot training information
eval_log <- cv_obj$evaluation_log
ggplot(eval_log,aes(x=iter)) + 
  coord_cartesian(ylim=c(0,0.4)) +
  geom_line(aes(y=train_rmse_mean),lwd=2,col='#0078D7') +
  geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
  geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
  geom_line(aes(y=test_rmse_mean),lwd=2,col='orange') +
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
xgb_ensemble_validation <- encode_type(ensemble_validation)
xgb_ensemble_validation <- polarise(MELBOURNE_CENTRE,xgb_ensemble_validation)
xgb_ensemble_validation_y <- log(xgb_ensemble_validation$price)
xgb_ensemble_validation_x <- xgb_ensemble_validation %>% 
    select(features) %>% as.matrix
xgb_ens_preds <- predict(xgb_model,newdata <- xgb_ensemble_validation_x)

#---------------------------------------------record for tuning-----------------

xgb_cv_error <- cv_obj$evaluation_log$test_rmse_mean %>% min
nam <- names(tune_log_xgb)
cv_error <- min(cv_obj$evaluation_log$test_rmse_mean)
tune_log_xgb <- rbind(tune_log_xgb,c((names(for_tune_log_xgb) %in% names(xgb_train0_x))*1,xgb_oof_error,xgb_cv_error))
names(tune_log_xgb) <- nam
tune_log_xgb

