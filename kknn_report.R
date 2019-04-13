#---------------------------prepare data----------------------------------------

train0_knn <- encode_type(train0)
features <- c('building_area'
              ,'lng'
              ,'lat'
              ,'year_built'
              ,'type_encoded'
              ,'nrooms'
              ,'land_area'
)

train0_y = log(train0_knn$price)
train0_x <- train0_knn %>% select(features)

#---------------Prepare for caret's optimisation--------------------------------

#caret's trainControl function demands training indicies
#simply passing -folds won't work
train_folds = lapply(folds,function(f){which(!(1:nrow(train0_knn) %in% f))})

#using folds created earlier, create an object to pass to caret 
#for cross validation
trainingParams = trainControl(index=train_folds,
                              indexOut=folds,
                              verbose=FALSE)

#create a dataframe of hyperparameter values to search
tunegrid = data.frame(kmax=rep(1:30,each=1),
                      distance=rep(1,30),
                      kernel=rep('epanechnikov',30)
)

#-----------------------------Run Caret-----------------------------------------

#Find the optimal kmax hyperparameter
knn_model = train(x=train0_x,
                  y=train0_y,
                  method='kknn',
                  metric='RMSE',
                  tuneGrid = tunegrid,
                  trControl = trainingParams
                  
)

#save the optimal hyperparamaters
tuned <- knn_model$bestTune

#---------------Create out-of-fold (OOF) predictions----------------------------

oof_preds = rep(NA,nrow(train0_knn))

#iterate over folds
for (i in 1:KFOLD) {
    fold = folds[[i]]
    
    #prepare fold specific data
    train0_x_fold = train0_x[-fold,]
    train0_y_fold = train0_y[-fold]
    val0_x_fold = train0_x[fold,]
    val0_y_fold = train0_y[fold]
    
    #call caret's train() to find the optimal kmax
    model =  train(x=train0_x_fold,
                   y=train0_y_fold,
                   method='kknn',
                   metric='RMSE',
                   tuneGrid=tuned,
                   trControl = trainControl('none')
                   
    )
    
    #compute prediction on the remaining fold
    preds = predict(model$finalModel,newdata=val0_x_fold)
    
    
    #add to the OOF predictions
    oof_preds[fold] = preds
}
knn_oof_error = sqrt(mean((oof_preds-train0_y)^2))
#-------------------------------------------plot--------------------------------
res <- knn_model$results
res <- select(res,c(kmax,distance,RMSE,MAE))
ggplot(res,aes(x=kmax)) + geom_line(aes(y=RMSE),lwd=2,color='#0078D7')
