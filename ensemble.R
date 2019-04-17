#----------------------------EDA------------------------------------------------
#out of fold pred acc
#knn_oof_error
#xgb_oof_error
#gam_oof_error

##################################################################

#---------------------------------------------data prep-------------------------

#setup ensembling train data by combining predictions on train0
#into a dataframe
ensemble_train_x <- cbind(xgb_oof_preds,knn_oof_preds,gam_oof_preds) %>%
    as.data.frame
ensemble_train_y <- log(train0$price)

#set up ensembling validation set by combining predictions on 
#ensemble_validation into a dataframe
ensemble_validation_x <- cbind(xgb_ens_preds,knn_ens_preds,gam_ens_preds) %>%
    as.data.frame
ensemble_validation_y <- log(ensemble_validation$price)

#-----------------------------Model Comparison----------------------------------

#accuracy with target
acc_df <- sapply(ensemble_train_x,function(x){
    sqrt(mean((x - log(train0$price) )^2))
}) %>% as.data.frame
names(acc_df) <- 'Accuracy (rmse)'
row.names(acc_df) <- c('xgboost','knn','gam')
acc_df %>% kable

#correlations with each other
cor(ensemble_train_x) %>% as.data.frame %>% kable

#correlations with target
cor_with_target <- sapply(ensemble_train_x,function(x){
    cor(x,log(train0$price))
}) %>% as.data.frame
names(cor_with_target) <- 'correlation with log(price)'
row.names(cor_with_target) <- c('xgboost','knn','gam')
cor_with_target %>% kable

#----------add features from the primary models to the meta features------------
feats <- c('lng','lat')

#get base features from the ensemble_validation set to combine with
#predictions from primary models
val_feats <- polarise(MELBOURNE_CENTRE,ensemble_validation) %>% encode_type %>%
    encode_method %>% select(feats)

#do the same for training
train_feats <- train0 %>% encode_type %>% encode_method %>% select(feats)

#combine these features to the ensembling data
ensemble_train_x <- ensemble_train_x %>% cbind(train_feats) 
ensemble_validation_x <- ensemble_validation_x %>% cbind(val_feats)

#---------------------------generate watchlist---------------------------------
#create a watchlist, xgboost will use the last element, (the validation set)
#when early stopping
watchlist<-list()
watchlist[['train']] <- xgb.DMatrix(data = as.matrix(ensemble_train_x),
                                   label =ensemble_train_y )
watchlist[['validation']] <- xgb.DMatrix(data = as.matrix(ensemble_validation_x),
                                        label = ensemble_validation_y)

#---------------------fit model-------------------------------------------------

#set params
PARAMS <- list(
    seed=0,
    objective='reg:linear',
    eta=0.001,
    #eta=0.005,
    eval_metric='rmse',
    max_depth=2,
    colsample_bytree=1,
    subsample=1
)

#fit the model
ens_mod <- xgb.train(
    data = watchlist$train,
    params =  PARAMS,
    nrounds =  1e+6,
    watchlist =  watchlist,
    verbose=T,
    early_stopping_rounds = 10000
    #early_stopping_rounds = 2000
    )


#---------------------------------------------plots------------------------------
eval_log <- gather(ens_mod$evaluation_log,key='dataset_measure',
                   value='score',c(train_rmse,validation_rmse))
eval_log$dataset_measure <- factor(eval_log$dataset_measure)

ggplot(eval_log,aes(x=iter,y=score,color=dataset_measure)) + 
    coord_cartesian(ylim=c(0.1,0.4)) +
    geom_line(lwd=2)


xgb_ens_fi <- xgb.importance(model=ens_mod)
xgb.plot.importance(xgb_ens_fi,measure='Gain')

#################################################################################
#-------------------comparison with primary
sapply(ensemble_validation_x,function(x){
    sqrt(mean((x - log(ensemble_validation$price) )^2))
})

#prepare validation for prediction
mat <- matrix(rep(NA,nrow(ensemble_validation_x)*ncol(ensemble_validation_x)),
              nrow = nrow(ensemble_validation_x))
for(i in 1:ncol(ensemble_validation_x)) {
    mat[,i] <- ensemble_validation_x[[i]]
}
preds <- predict(ens_mod , newdata = mat)
sqrt(mean((ensemble_validation_y - preds)^2))
