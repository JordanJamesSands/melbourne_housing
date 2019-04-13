library(caret)

#KFOLD=10

#kfold model
train0_knn = encode_type(train0)
train0_knn = select_cols(train0_knn,numeric_only = T)


train0_x = select(train0_knn,-price)
#-------------------------HACK------------------
train0_x <- select(train0_x,-dist_cbd)
#-----------------------------------------------
train0_y = log(train0_knn$price)

#data prep
#dilation_list = list()
#for(colname in names(train0_x)) {
#    dilation_list[[colname]] = 1
#}

rec_sds = lapply(train0_x,function(x){1/sd(x)})

apply_DV <- function(df,dv) {
    for(colname in names(df)) {
        df_col = df[[colname]]
        dilation_factor = dv[[colname]]
        df[[colname]] = (df_col - mean(df_col))*dilation_factor + mean(df_col)
    }
    return(df)
}

#set sd to 1
train0_x = apply_DV(train0_x,rec_sds)
sapply(train0_x,sd)

#------------------------ dilate the feature space-----------------
#dilation_list = list()
#for(colname in names(train0_x)) {
#    dilation_list[[colname]] = 1
#}
#dilation_list$nrooms = 2
#train0_x <- select(train0_x,c(building_area,lng,lat))
train0_x = apply_DV(train0_x,dilation_list)
#------------------------------------------------------------------

#caret's trainControl function demands training indicies, simple passing -folds won't work
train_folds = lapply(folds,function(f){which(!(1:nrow(train0_knn) %in% f))})

#using folds from splitting0.R
trainingParams = trainControl(index=train_folds,
                              indexOut=folds,
                              verbose=T)

#letting caret make its own folds
#set.seed(034)
#trainingParams = trainControl(method='repeatedcv',
#                              number=KFOLD,
#                              repeats=1)

#knn_model = train(x=train0_x,
#                  y=train0_y,
#                  method='knn',
#                  metric='RMSE',
#                  trControl = trainingParams,
#                  tuneGrid=data.frame(k=1:50),
#                  preProcess = c('center','scale')
#            )
#-------------------------------------------------------------------eXP
knn_model = train(x=train0_x,
                  y=train0_y,
                  method='kknn',
                  metric='RMSE',
                  
                  #preProcess = c(),
                  #preProcess = c('center','scale'),
                  #tuneGrid = data.frame(kmax=1:20,distance=rep(2,20),kernel=rep('optimal',20)),
                  trControl = trainingParams

)
tuned <- knn_model$bestTune
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
                   #preProcess = c('center','scale'),
                   tuneGrid=tuned
    )
    
    preds = predict(model$finalModel,newdata=val0_x_fold)
    
    #plot(preds,val0_y_fold,main=paste('fold',i))
    cat('true/predicted correlation:',cor(preds,val0_y_fold),'\n')
    rmse = sqrt(mean((preds-val0_y_fold )^2))
    cat('rmse:',rmse,'\n')
    
    oof_preds[fold] = preds
}
oof_error = sqrt(mean((oof_preds-train0_y)^2))
oof_error
#----------------------------------------------------------------------exp end
break


OPTIMAL_K = knn_model$bestTune$k
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
                   method='knn',
                   metric='RMSE',
                   trControl = trainControl('none'),
                   tuneGrid=data.frame(k=OPTIMAL_K)
    )
    
    preds = predict(model$finalModel,newdata=val0_x_fold)
    
    #plot(preds,val0_y_fold,main=paste('fold',i))
    cat('true/predicted correlation:',cor(preds,val0_y_fold),'\n')
    rmse = sqrt(mean((preds-val0_y_fold )^2))
    cat('rmse:',rmse,'\n')
    
    oof_preds[fold] = preds
}
oof_error = sqrt(mean((oof_preds-train0_y)^2))
print(OPTIMAL_K)
print(oof_error)


