library(caret)

#kfold model
train0_knn = encode_type(train0)
train0_knn = select_cols(train0_knn,numeric_only = T)


train0_x = select(train0_knn,-price)
#-------------------------HACK------------------
#train0_x <- select(train0_x,-dist_cbd)
#-----------------------------------------------
train0_y = log(train0_knn$price)


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
#train0_x = apply_DV(train0_x,rec_sds)
sapply(train0_x,sd)

#------------------------ dilate the feature space-----------------
#train0_x <- select(train0_x,c(building_area,lng,lat))
#train0_x = apply_DV(train0_x,dilation_list)
#------------------------------------------------------------------

#caret's trainControl function demands training indicies, simple passing -folds won't work
train_folds = lapply(folds,function(f){which(!(1:nrow(train0_knn) %in% f))})

#using folds from splitting0.R
trainingParams = trainControl(index=train_folds,
                              indexOut=folds,
                              verbose=T)

#-------------------------------------------------------------------eXP
#optimal kernel gives score independant of dilations!!!
TG = data.frame(kmax=1:20,distance=rep(2,20),kernel=rep('epanechnikov',20))
knn_model = train(x=train0_x,
                  y=train0_y,
                  method='kknn',
                  metric='RMSE',
                  tuneGrid = TG,
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
