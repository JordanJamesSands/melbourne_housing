mod_2 <-train.kknn(train0_y ~ . , data=train0_x,kmax=10,distance=1,kernel='epanechnikov')






K_vec =5:15
for(K in K_vec) {
    print(K)
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
        
        mod_2 <-train.kknn(train0_y_fold ~ . , data=train0_x_fold,kmax=K,distance=1,kernel='epanechnikov')
        
        #compute prediction on the remaining fold
        preds = predict(mod_2,newdata=val0_x_fold)
        
        #compute accuracy
        rmse = sqrt(mean((preds-val0_y_fold )^2))
        #cat('rmse:',rmse,'\n')
        
        #add to the OOF predictions
        oof_preds[fold] = preds
    }
    oof_error = sqrt(mean((oof_preds-train0_y)^2))
    print(oof_error)
}
#the model fits a kernel presumably each time its run, 
#this might be why oof_error and cv_error are so different
#or maybe its not actually doing cv

print(tuned)
