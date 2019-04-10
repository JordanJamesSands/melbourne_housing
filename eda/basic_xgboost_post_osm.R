
#------------------------Functions------------------------------------------
plot_cv <- function(cv_obj,xlim=NULL,ylim=NULL) {
    eval_data = cv_obj$evaluation_log
    if(is.null(xlim)){ xlim=range(eval_data$iter) }
    if(is.null(ylim)) {ylim=range(eval_data[,c(2,4)])}
    plot(NULL,NULL,type='n',xlim=xlim,ylim=ylim,ylab='rmse')
    
    #plot train
    lines(eval_data[,2],col='green',lwd=2)
    lines(eval_data[,2]-eval_data[,3],col='green',lwd=2,lty=2)
    lines(eval_data[,2]+eval_data[,3],col='green',lwd=2,lty=2)
    
    #plot test
    lines(eval_data[,4],col='red',lwd=2)
    lines(eval_data[,4]-eval_data[,5],col='red',lwd=2,lty=2)
    lines(eval_data[,4]+eval_data[,5],col='red',lwd=2,lty=2)
    
    abline(v=0,lwd=1,lty=4)
    
    min_test_error = min(eval_data[,4])
    abline(h=min_test_error,lwd=1,lty=2)
    text(x=0.05*xlim[2],y=min_test_error-0.005,round(min_test_error,4))
}

#-----------------------load dependencies and declare global vars-------------
library(caret)
library(xgboost)
library(pdp)
library(vip)
library(dplyr)
KFOLD = 10

#---------------------prepare data for xgboost api---------------------------
train0_xgb_prep = encode_type(train0)
train0_xgb_prep = select_cols(train0_xgb_prep,numeric_only = T,extra_feature_names ='ntrain_3000')
train0_x = select(train0_xgb_prep,-price)
train0_y = log(train0_xgb_prep$price)
Dtrain0 = xgb.DMatrix(data=as.matrix(train0_x),label=train0_y)

#--------------- Write parameters-----------------------------
PARAMS = list(
    seed=0,
    objective='reg:linear',
    eta=0.1,
    eval_metric='rmse',
    max_depth=2,
    colsample_bytree=1,
    subsample=1
    
)

#------------------------cross validation-------------------------
cv_obj = xgb.cv(params=PARAMS,
                data=Dtrain0,
                folds=folds,
                verbose=T,
                nrounds=6000,
                early_stopping_rounds=50
)
plot_cv(cv_obj,ylim=c(0.1,0.3))

#---------------------------generate watchclist-------------------------------
watchlist=list()
for (i in 1:KFOLD) {
    print(i)
    fold = folds[[i]]
    watchlist[[i]] = xgb.DMatrix(data = as.matrix(train0_x[fold,]) , label = train0_y[fold])
}
names(watchlist) = sapply(1:KFOLD,function(x){paste0('fold',x)})

#---------------------------Fit KFOLD many models--------------------------
OPTIMAL_NROUNDS=cv_obj$best_ntreelimit
oof_preds = rep(NA,nrow(train0))
for (i in 1:KFOLD) {
    cat(paste('fold number:',i,'of',KFOLD,'\n'))
    fold = folds[[i]]
    
    train0_x_fold = train0_x[-fold,]
    train0_y_fold = train0_y[-fold]
    Dtrain0_fold = xgb.DMatrix(data=as.matrix(train0_x_fold),label=train0_y_fold)
    
    val0_x_fold = train0_x[fold,]
    val0_y_fold = train0_y[fold]
    Dval0_fold = xgb.DMatrix(data=as.matrix(val0_x_fold),label=val0_y_fold)
    
    
    model = xgb.train(params=PARAMS,
                      data=Dtrain0_fold,
                      nrounds=OPTIMAL_NROUNDS,
                      verbose=0,
                      watchlist=watchlist)
    
    preds = predict(model,newdata=Dval0_fold)
    #plot(preds,val0_y_fold,main=paste('fold',i))
    cat('true/predicted correlation:',cor(preds,val0_y_fold),'\n')
    rmse = sqrt(mean((preds-val0_y_fold )^2))
    cat('rmse:',rmse,'\n')
    
    oof_preds[fold] = preds
}
cat('rmse OOF predictions:',sqrt(mean((oof_preds-train0_y )^2)),'\n')

#---- train model on all train0------------------

model_all = xgb.train(params=PARAMS,
                      data=Dtrain0,
                      nrounds=OPTIMAL_NROUNDS
)
vip(model_all,num_features=ncol(train0_x))



