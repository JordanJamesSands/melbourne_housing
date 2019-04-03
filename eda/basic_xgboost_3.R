library(caret)
library(xgboost)
library(pdp)
library(vip)
KFOLD = 10

train0 = select_cols(train0,numeric_only = T)

train0_x = select(train0,-price)
train0_y = log(train0$price)

Dtrain0 = xgb.DMatrix(data=as.matrix(train0_x),label=train0_y)

PARAMS = list(
    objective='reg:linear',
    eta=0.1,
    eval_metric='rmse',
    max_depth=4,
    colsample_bytree=1,
    subsample=1

)
cv_obj = xgb.cv(params=PARAMS,
                data=Dtrain0,
                folds=folds,
                verbose=T,
                nrounds=6000,
                early_stopping_rounds=50
                )
plot_cv(cv_obj,ylim=c(0.1,0.3))

#generate watchclist
watchlist=list()
for (i in 1:KFOLD) {
    print(i)
    fold = folds[[i]]
    watchlist[[i]] = xgb.DMatrix(data = as.matrix(train0_x[fold,]) , label = train0_y[fold])
}
names(watchlist) = sapply(1:KFOLD,function(x){paste0('fold',x)})

model = xgb.train(params=PARAMS,
                  data=Dtrain0,
                  nrounds=500,
                  verbose=1,
                  watchlist=watchlist)



#FUN
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
    abline(h=min_test_error,lwd=2)
    text(x=0.05*xlim[2],y=min_test_error-0.005,round(min_test_error,4))
}

