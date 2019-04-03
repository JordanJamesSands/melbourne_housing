library(caret)
library(xgboost)
KFOLD=5
cctrain0 = train0[complete.cases(train0),]
ccfolds = createFolds(cctrain0$price,k=KFOLD,list=TRUE)
sapply(ccfolds,length)
NROUNDS=1000

#setup data for xgboost
cctrain0_x = as.matrix(select(cctrain0,c(nrooms,nbathroom,lng,lat,ncar)))
cctrain0_y = cctrain0$price
Dcctrain0_select = xgb.DMatrix(data = cctrain0_x,label=log(cctrain0_y))



#parameters
PARAMS = list(
    objective='reg:linear',
    eta=0.1,
    eval_metric='rmse',
    #min_child_weight=,
    max_depth=2
)
#train model
mod <- xgb.cv(params=PARAMS,
              data=Dcctrain0_select, 
              folds=ccfolds,
              nrounds=NROUNDS,
              verbose=T,
              early_stopping_rounds=5
              )
mod$evaluation_log

d2 <- select(mod$evaluation_log,-iter)
ylim = c(min(d2),0.4)
with(mod$evaluation_log,
     plot(NULL,NULL,type='n',ylim=ylim,xlim=c(1,NROUNDS))
     )

d2$train_mean_plus_sd = d2$train_rmse_mean + d2$train_rmse_std
d2$train_mean_minus_sd = d2$train_rmse_mean - d2$train_rmse_std
d2$test_mean_plus_sd = d2$test_rmse_mean + d2$test_rmse_std
d2$test_mean_minus_sd = d2$test_rmse_mean - d2$test_rmse_std

lines(d2$test_rmse_mean,col='red',lwd=2)
lines(d2$test_mean_minus_sd,col='red',lty=2)
lines(d2$test_mean_plus_sd,col='red',lty=2)

lines(d2$train_rmse_mean,col='green',lwd=2)
lines(d2$train_mean_minus_sd,col='green',lty=2)
lines(d2$train_mean_plus_sd,col='green',lty=2)

pdp_data = partial(mod,pred.var='lng',ice=FALSE,train=cctrain0_x)
