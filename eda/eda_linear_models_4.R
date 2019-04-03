cctrain0 = train0[complete.cases(train0),]
N = dim(cctrain0)[1]
pred_df = data.frame(prediction=rep(NA,N))
model_list = list()

ccfolds = createFolds(cctrain0$price,k=4,list=TRUE)
sapply(folds,length)

i=1
for (fold in folds){
    print('newfold')
    train = train0[-fold,]
    val = train0[fold,]
    
    model <- lm(log(price) ~ nrooms + nbathroom + ncar + lat + lng + type,data=train)
    model_list[[i]] = model
    i = i +1
    #print(summary(model)$coef)
    pred_df[fold,] = predict(model,newdata = val)
    
}

prices = log(train0$price)
preds = pred_df$prediction
sq_resid = (preds-prices)^2
qqnorm(sq_resid)
plot(prices,sq_resid,pch=19,col=rgb(0,0,0,0.2))
plot(prices,sqrt(sq_resid),pch=19,col=rgb(0,0,0,0.2))

#estimate of accuracy
sqrt(  mean((exp(prices) - exp(preds))^2,na.rm=T))

lapply(model_list,function(x){summary(x)$coef})

lapply(model_list,function(x){summary(x)$r.squared})

model_all = lm(log(price) ~ nrooms + nbathroom + ncar + lat + lng,data=train)

#PLOTS AGAINST PRICE
plot(train$price,predict(model_all,newdata = train),pch=19,col=rgb(0,0,0,0.2))
plot(jitter(train$nrooms),predict(model_all,newdata = train),pch=19,col=rgb(0,0,0,0.2))
plot(jitter(train$nbathroom),predict(model_all,newdata = train),pch=19,col=rgb(0,0,0,0.2))
plot(jitter(train$ncar),predict(model_all,newdata = train),pch=19,col=rgb(0,0,0,0.2))

plot(jitter(train$nbathroom),predict(model_all,newdata = train),pch=19,col=rgb(0,0,0,0.2))

#this dosnt look linear
plot(jitter(train$ncar),predict(model_all,newdata = train),pch=19,col=rgb(0,0,0,0.2))
#
plot(train$lng,predict(model_all,newdata = train),pch=19,col=rgb(0,0,0,0.2))
plot(train$lat,predict(model_all,newdata = train),pch=19,col=rgb(0,0,0,0.2))

#PLOTS AGAINST RESIDUALS


#
#
#

