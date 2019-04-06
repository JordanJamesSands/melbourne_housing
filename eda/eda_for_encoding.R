with(train0,
     plot(jitter(as.numeric(type),2),log(price))
)
with(train0,
     plot(jitter(as.numeric(method,2)),log(price))
)
with(train0,
     plot(council_area,log(price))
)
with(train0,
     plot(region,log(price))
)




qplot(x=type,y=log(price),data=train0,geom='jitter')
qplot(x=type,y=log(price),data=train0,geom='violin')
#encode in this order : unit , townhouse, house

qplot(x=method,y=log(price),data=train0,geom='jitter')
qplot(x=method,y=log(price),data=train0,geom='violin')
anova(lm(log(price)~method,data=train0),lm(log(price)~1,data=train0))

qplot(x=council_area,y=log(price),data=train0,geom='jitter')
qplot(x=council_area,y=log(price),data=train0,geom='violin')

qplot(x=region,y=log(price),data=train0,geom='jitter')
qplot(x=region,y=log(price),data=train0,geom='violin')

