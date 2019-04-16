#prepare oof predictions for test
training_data <- rbind(train0,ensemble_validation)

#prepare gam
gam_training_data <- training_data %>% polarise(MELBOURNE_CENTRE,.)
gam_test_data <- test_data %>% polarise(MELBOURNE_CENTRE,.)

#prepare xgb
xgb_training_data_y <- log(training_data$price)
xgb_training_data_x <- training_data %>% encode_type %>% 
    polarise(MELBOURNE_CENTRE,.) %>% 
    select(xgb_features)
xgb_test_data <- test_data %>% encode_type %>% polarise(MELBOURNE_CENTRE,.) %>% 
    select(xgb_features)

#prepare knn
knn_training_data_y <- log(training_data$price)
knn_training_data_x <- training_data %>% encode_type %>% select(knn_features)
knn_test_data <- test_data %>% encode_type %>% select(knn_features)



xgb_oof_preds_2 <- rep(NA,nrow(training_data))
knn_oof_preds_2 <- rep(NA,nrow(training_data))
gam_oof_preds_2 <- rep(NA,nrow(training_data)) 

folds_2 <- createFolds(log(training_data$price),k=5,list=TRUE)


for(fold in folds_2) {
    print('newfold')
    #-------------------------------gam-----------------------------------------
    #prepare gam data
    gam_train_fold <- gam_training_data[-fold,]
    gam_val_fold <- gam_training_data[fold,]
    
    #fit gam model
    gam_model <- gam(formula = form ,
                          data =  gam_train_fold,
                          #control = gc,
                          family='gaussian'
    )
    #produce predictions
    gam_oof_preds_2[fold] <- predict(gam_model , newdata = gam_val_fold)
    
    #--------------------------xgb----------------------------------------------
    xgb_train_x_fold <- xgb_training_data_x[-fold,]
    xgb_train_y_fold <- xgb_training_data_y[-fold]
    
    xgb_val_y_fold <- xgb_training_data_y[fold]
    xgb_val_x_fold <- xgb_training_data_x[fold,]
    
    #fit xgb model
    xgb_model <- xgboost(data = as.matrix(xgb_train_x_fold), 
                                   label = xgb_train_y_fold, 
                                   params = PARAMS,
                                   verbose=FALSE,
                                   nrounds = OPTIMAL_NROUNDS
    )
    xgb_oof_preds_2[fold] <- predict(xgb_model,as.matrix(xgb_val_x_fold))
    
    #-------------------------knn-----------------------------------------------
    knn_train_x_fold <- knn_training_data_x[-fold,]
    knn_train_y_fold <- knn_training_data_y[-fold]
    
    knn_val_x_fold <- knn_training_data_x[fold,]
    knn_val_y_fold <- knn_training_data_y[fold]
    
    knn_model <-  train(x=knn_train_x_fold,
                    y=knn_train_y_fold,
                    method='kknn',
                    metric='RMSE',
                    tuneGrid=tuned,
                    trControl = trainControl('none')
    )
    knn_oof_preds_2 <- predict(knn_model , newdata = knn_val_x_fold)
}

#---------------generate metafeatures for the final test set--------------------


gam_model <- gam(formula = form ,
                 data =  gam_training_data,
                 #control = gc,
                 family='gaussian'
)
test_gam_preds <- predict(gam_model , newdata = gam_test_data)

xgb_model <- xgboost(data = as.matrix(xgb_training_data_x), 
                     label = xgb_training_data_y, 
                     params = PARAMS,
                     verbose=FALSE,
                     nrounds = OPTIMAL_NROUNDS
)
test_xgb_preds <- predict(xgb_model , newdata = as.matrix(xgb_test_data))

knn_model <-  train(x=knn_training_data_x,
                    y=knn_training_data_y,
                    method='kknn',
                    metric='RMSE',
                    tuneGrid=tuned,
                    trControl = trainControl('none')
)
test_knn_preds <- predict(knn_model , newdata = )

test_data_meta <- cbind(test_xgb_preds,test_knn_preds,test_gam_preds)