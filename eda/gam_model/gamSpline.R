#gamSpline has potential, with ~0.205 rmse with basic understanding, plots look 
#ridiculous too, maybe could improve significantly

#---------------------------prepare data----------------------------------------
train0_knn <- encode_type(train0)
train0_knn <- select_cols(train0_knn,numeric_only = T)
train0_x <- select(train0_knn,-price)

#-------------------------HACK------------------
#train0_x <- select(train0_x,-dist_cbd)
#-----------------------------------------------
#c(building_area,lng,lat,year_built,type_encoded,nrooms,land_area) is alright,


train0_y = log(train0_knn$price)

#variable selection
train0_x <- select(train0_x,
                   c(building_area,
                     lng,
                     lat,
                     year_built,
                     type_encoded,
                     nrooms,
                     land_area))
#actually, polar might be better
#sub in polar stuff?
#---------------------prepare data for xgboost api---------------------------
train0_xgb_prep = encode_type(train0)
train0_xgb_prep = select_cols(train0_xgb_prep,numeric_only = T,
                              extra_feature_names ='ntrain_3000',
                              include_impute_flags = F)
train0_x = select(train0_xgb_prep,-price)

#-------------------------HACK------------------
MELBOURNE_CENTRE = c(144.9631,-37.8136)
train0_x <- polarise(MELBOURNE_CENTRE,train0_x) %>% select(-c(lng,lat))
#train0_x <- polarise(train0_x)

#train0_x <- select(train0_x,-dist_cbd)
#-----------------------------------------------
train0_y = log(train0_xgb_prep$price)

for(var in names(train0_x)) {
    print(var)
    train0_x[[var]] <- train0_x[[var]] - mean(train0_x[[var]])
    train0_x[[var]] <- train0_x[[var]]/sd(train0_x[[var]])
}
train0_x <- select(train0_x,-c(land_area,propcount,ntrain_3000))

train_folds = lapply(folds,function(f){which(!(1:nrow(train0_knn) %in% f))})
trainingParams = trainControl(index=train_folds,
                              indexOut=folds,
                              verbose=T)

mod = train(train0_x,train0_y,method='gamSpline',trControl = trainingParams,tuneGrid=data.frame(df=15:35))
tuned = mod$bestTune

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
    
    #call caret's train()
    model =  train(x=train0_x_fold,
                   y=train0_y_fold,
                   method='gamSpline',
                   tuneGrid=tuned,
                   #tuneGrid=data.frame(df=15),
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
