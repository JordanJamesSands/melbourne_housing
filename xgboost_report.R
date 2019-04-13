#---------------------prepare data for xgboost api------------------------------

#encode the property type, (house, townhouse, unit) as a number
train0_xgb_prep = encode_type(train0)

#create polar coordinates with melbourne in the centre
MELBOURNE_CENTRE = c(144.9631,-37.8136)
train0_xgb_prep <- polarise(MELBOURNE_CENTRE,train0_xgb_prep)

#select features, this is the result of trial and error
features <- c('building_area'
              #,'lng'
              #,'lat'
              ,'dist_cbd'
              ,'bearing'
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
              ,'school_min_dist'
              
              #,'ntrain_3000'
              ,'train_min_dist'
              
              #,'nsupermarket_2000'
              #,'supermarket_min_dist'
)

#prepare data for xgboost
train0_y = log(train0_xgb_prep$price)
train0_x <- train0_xgb_prep %>% select(features)
#create an xgboost specific data object
Dtrain0 = xgb.DMatrix(data=as.matrix(train0_x),label=train0_y)

#----------------------------------Write parameters-----------------------------

#These have been tuned to minimise cross validated error
PARAMS = list(
    seed=0,
    objective='reg:linear',
    eta=0.05,
    eval_metric='rmse',
    max_depth=6,
    colsample_bytree=0.8,
    subsample=0.8
    
)

#--------------------------------cross validation-------------------------------

#Run cross validation, setting the seed first to ensure reproducibility
set.seed(457835)
cv_obj = xgb.cv(params=PARAMS,
                data=Dtrain0,
                folds=folds,
                verbose=T,
                nrounds=1e+6,
                early_stopping_rounds=200
)

#------------------------plot cross validation data-----------------------------

#Get aa better idea of the training process
ggplot(eval_log,aes(x=iter)) + 
    coord_cartesian(ylim=c(0.1,0.4)) +
    geom_line(aes(y=train_rmse_mean),lwd=2,col='#0078D7') +
    geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
    geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
    geom_line(aes(y=test_rmse_mean),lwd=2,col='orange') +
    geom_line(aes(y=test_rmse_mean + test_rmse_std),lwd=1,col='orange',lty=2) +
    geom_line(aes(y=test_rmse_mean - test_rmse_std),lwd=1,col='orange',lty=2)

#-----------------Generate out of fold (OOF) predictions------------------------

#save the optimal number of trees
OPTIMAL_NROUNDS=cv_obj$best_ntreelimit

#initialise the OOF prediction vector
oof_preds = rep(NA,nrow(train0))

for (i in 1:KFOLD) {
    fold = folds[[i]]
    
    #set up fold specific data
    train0_x_fold = train0_x[-fold,]
    train0_y_fold = train0_y[-fold]
    Dtrain0_fold = xgb.DMatrix(data=as.matrix(train0_x_fold),label=train0_y_fold)

    val0_x_fold = train0_x[fold,]
    val0_y_fold = train0_y[fold]
    Dval0_fold = xgb.DMatrix(data=as.matrix(val0_x_fold),label=val0_y_fold)
    
    #train the model
    model = xgb.train(params=PARAMS,
                      data=Dtrain0_fold,
                      nrounds=OPTIMAL_NROUNDS,
                      verbose=0,
                      watchlist=watchlist)
    
    #make predictions
    preds = predict(model,newdata=Dval0_fold)
    
    #save the predictions to the OOF vector
    oof_preds[fold] = preds
}

#compute error
xgb_oof_error <- sqrt(mean((oof_preds-train0_y )^2))

#------------------------train model on all train0------------------------------

#Now retraining the model on all data for exploratory purposes
model_all <- xgboost(data = as.matrix(train0_x), 
                     label = train0_y , 
                     params = PARAMS,
                     nrounds = OPTIMAL_NROUNDS
)

#compute and plot feature importances
xgb_fi <- xgb.importance(feature_names= c(),model=model_all)
xgb.plot.importance(xgb_fi,measure='Gain')


#----------------------------record for tuning----------------------------------

xgb_cv_error = cv_obj$evaluation_log$test_rmse_mean %>% min
nam <- names(tune_log_xgb)
cv_error <- min(knn_model$results$RMSE)
tune_log_xgb <- rbind(tune_log_xgb,c((names(for_tune_log_xgb) %in% names(train0_x))*1,xgb_oof_error,xgb_cv_error))
names(tune_log_xgb) <- nam
tune_log_xgb
