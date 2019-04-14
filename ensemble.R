#----------------------------EDA------------------------------------------------
#oof_cors
cor(train1_x[,1],train1_y)
cor(train1_x[,2],train1_y)
cor(train1_x[,1],train1_x[,2])

#out of fold pred acc
knn_oof_error
xgb_oof_error

#---------------------------------------------data prep-------------------------

#setup
ensemble_train_x <- cbind(xgb_oof_preds,knn_oof_preds) %>% as.data.frame
ensemble_train_y <- log(train0$price)
ensemble_validation_x <- cbind(xgb_ens_preds,knn_ens_preds) %>% as.data.frame
ensemble_validation_y <- log(ensemble_validation$price)

#-----------------------------Model Comparison----------------------------------

#correlations with each other
cor(ensemble_train_x)
#correlations with target
sapply(ensemble_train_x,function(x){cor(x,log(train0$price))})
#accuracy with target
sapply(ensemble_train_x,function(x){
    sqrt(mean((x - log(train0$price) )^2))
})


#correlations with each other
cor(ensemble_validation_x)
#correlations with target
sapply(ensemble_validation_x,function(x){cor(x,ensemble_validation_y)})
#accuracy with target
sapply(ensemble_validation_x,function(x){
    sqrt(mean((x - log(ensemble_validation$price) )^2))
})

#----------add features from the primary models to the meta features------------
feats <- c('dist_cbd','bearing')
train0 <- polarise(MELBOURNE_CENTRE,train0)
ensemble_validation <- polarise(MELBOURNE_CENTRE,ensemble_validation)
train_feats <- train0 %>% select(feats)
val_feats <- ensemble_validation %>% select(feats)
ensemble_train_x <- ensemble_train_x %>% cbind(train_feats)
ensemble_validation_x <- ensemble_validation_x %>% cbind(val_feats)

#---------------------------generate watchclist---------------------------------
watchlist<-list()
watchlist[['train']] <- xgb.DMatrix(data = as.matrix(ensemble_train_x),
                                   label =ensemble_train_y )
watchlist[['validation']] <- xgb.DMatrix(data = as.matrix(ensemble_validation_x),
                                        label = ensemble_validation_y)
#params
PARAMS <- list(
    seed=0,
    objective='reg:linear',
    eta=0.005,
    eval_metric='rmse',
    max_depth=2,
    colsample_bytree=0.8,
    subsample=0.8
)

#prep for xgboost
Dtrain_ens <- xgb.DMatrix(data=as.matrix(ensemble_train_x),label=ensemble_train_y)

ens_mod <- xgb.train(
    data =  Dtrain_ens,
    params =  PARAMS,
    nrounds =  1e+6,
    watchlist =  watchlist,
    early_stopping_rounds = 2000
    )
ens_mod$best_iteration
ens_mod$best_score
eval_log <- gather(ens_mod$evaluation_log,key='dataset_measure',value='score',c(train_rmse,validation_rmse))
eval_log$dataset_measure <- factor(eval_log$dataset_measure)

#---------------------------------------------plot------------------------------
ggplot(eval_log,aes(x=iter,y=score,color=dataset_measure)) + 
    coord_cartesian(ylim=c(0.1,0.4)) +
    geom_line(lwd=2)
xgb_ens_fi <- xgb.importance(model=ens_mod)
xgb.plot.importance(xgb_ens_fi,measure='Gain')

