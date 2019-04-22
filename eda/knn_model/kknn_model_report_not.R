#NOT ACTUALLY FOR THE REPORT?
#prepare data
train0_knn = encode_type(train0)
train0_knn = select_cols(train0_knn,numeric_only = T)
train0_x = select(train0_knn,-price)
#-------------------------HACK------------------
train0_x <- select(train0_x,-dist_cbd)
#-----------------------------------------------
train0_y = log(train0_knn$price)

#found using 5 fold cross validation
tuned <- data.frame(kmax=15,distance=2,kernel='epanechnikov')

#create OOF predictions
oof_preds = rep(NA,nrow(train0_knn))
for (i in 1:KFOLD) {
    cat(paste('fold number:',i,'of',KFOLD,'\n'))
    fold = folds[[i]]
    
    train0_x_fold = train0_x[-fold,]
    train0_y_fold = train0_y[-fold]
    
    val0_x_fold = train0_x[fold,]
    val0_y_fold = train0_y[fold]
    
    model =  train(x=train0_x,
                   y=train0_y,
                   method='kknn',
                   metric='RMSE',
                   trControl = trainControl('none'),
                   tuneGrid=tuned
    )
    
    preds = predict(model$finalModel,newdata=val0_x_fold)
    cat('true/predicted correlation:',cor(preds,val0_y_fold),'\n')
    rmse = sqrt(mean((preds-val0_y_fold )^2))
    cat('rmse:',rmse,'\n')
    oof_preds[fold] = preds
}
print(tuned)
oof_error = sqrt(mean((oof_preds-train0_y)^2))
oof_error
