#---------------------------prepare data----------------------------------------
train0_knn <- encode_type(train0)

features <- c('building_area',
              'lng',
              'lat',
              'year_built',
              'type_encoded',
              'nrooms',
              'land_area'#,
              #'nbbq_1000'
              #'ntrain_3000'
)

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
              #,'nbathroom'
              #,'ncar'
              
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
                              verbose=T)

#create a dataframe of hyperparameter values to search
tunegrid = data.frame(kmax=rep(1:10,each=1),
                      distance=rep(1,10),
                      kernel=rep('epanechnikov',10)
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
    cat(paste('fold number:',i,'of',KFOLD,'\n'))
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
    
    #compute accuracy
    rmse = sqrt(mean((preds-val0_y_fold )^2))
    cat('rmse:',rmse,'\n')
    
    #add to the OOF predictions
    oof_preds[fold] = preds
}

#the model fits a kernel presumably each time its run, 
#this might be why oof_error and cv_error are so different
#or maybe its not actually doing cv

print(tuned)
oof_error = sqrt(mean((oof_preds-train0_y)^2))
oof_error

#-------------------------------------------plot--------------------------------
res <- knn_model$results
res <- select(res,c(kmax,distance,RMSE,MAE))
ggplot(res,aes(x=kmax)) + geom_line(aes(y=RMSE),lwd=2,color='#0078D7')

#---------------------------------------------record for tuning-----------------
nam <- names(tune_log)
cv_error <- min(knn_model$results$RMSE)
tune_log <- rbind(tune_log,c((names(for_tune_log) %in% names(train0_x))*1,oof_error,cv_error))
names(tune_log) <- nam
tune_log
