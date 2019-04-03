library(xgboost)
library(caret)
K_FOLD = 5
cctrain0 = train0[complete.cases(train0),]
ccfolds = createFolds(cctrain0$price,k=K_FOLD,list=TRUE)
sapply(ccfolds,length)



cctrain0_select = select(cctrain0,c(nrooms,nbathroom,lng,lat,ncar,price))
Dcctrain0_select = xgb.DMatrix(data = as.matrix(cctrain0_select),label=cctrain0_select$price)
PARAMS = list(
    objective='reg:linear',
    eta=0.1,
    eval_metric='rmse',
    #min_child_weight=,
    max_depth=2
)
#generate watchclist
watchlist=list()
for (i in 1:K_FOLD) {
    print(i)
    fold = ccfolds[[i]]
    watchlist[[i]] = xgb.DMatrix(data = as.matrix(cctrain0_select[fold,]) , label = cctrain0_select[fold,]$price)
    
}
names(watchlist) = c('fold1','fold2','fold3','fold4','fold5')
#WATCHLIST = list(
#    data=Dcctrain0_select
#)
mod_list = list()
i=1
NROUNDS=1000
for(fold in ccfolds) {
    print('newfold')
    train = cctrain0_select[-fold,]
    val = cctrain0_select[fold,]
    Dtrain = xgb.DMatrix(data = as.matrix(select(train,-price)),label=train$price)
    
    #use xgb.cv instead
    
    mod <- xgb.train(params=PARAMS,data=Dtrain,nrounds=NROUNDS,verbose=1,watchlist=watchlist)
    
    mod_list[[i]] = mod
    i = i +1
}

plot_error <- function(model,ymax=999999999999) {
    d = model$evaluation_log
    min_err = min(select(d,-iter))
    max_err = min(max(select(d,-iter)),ymax)
    #max_err = max(select(d,-iter))
    plot(NULL,NULL,type='n',xlim=c(0,NROUNDS),ylim=c(min_err,max_err),xlab='iterations',ylab='error')
    d2 = select(d,-iter)
    j=1
    for (col in names(d2)) {
        print(col)
        lines(d2[[col]],col=j)
        j=j+1
    }

        
    #lapply(select(d,-iter),function(x){lines(x)})
    
}
plot_error(mod_list[[1]])
plot_error(mod_list[[2]])
plot_error(mod_list[[3]])
plot_error(mod_list[[4]])
plot_error(mod_list[[5]])



#mod <- xgb.train(params=PARAMS,data=Dcctrain0_select,nrounds=10,verbose=T,watchlist=WATCHLIST)

