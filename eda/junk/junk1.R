#eda1.1
g1 <- ggplot(data=subset(d,nbedroom<10 & nbathroom<6), aes(x=nbedroom,y=log(price)))
print(g1 + geom_jitter(alpha=0.6,aes(color=factor(nbathroom))) + geom_smooth(method='lm'))
