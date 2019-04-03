library(ggplot2)
library(lattice)

#date musn't be right
plot(t$date,log(t$price),pch=19,col=rgb(0,0,0,0.05))

g1 <- ggplot(data=subset(d,nbedroom<10 & nbathroom<6), aes(x=nbedroom,y=log(price)))
print(g1 + geom_jitter(alpha=0.2) + geom_smooth(method='lm'))

#interaction confirmed, the more bathrooms a place has the less impact more bedrooms have
print(g1 + geom_jitter(alpha=0.2) +facet_grid(nbathroom~.) + geom_smooth(method='lm'))


g2 <- ggplot(data=subset(d,nbedroom<10 & nbathroom<6), aes(x=nbathroom,y=log(price)))
print(g2 + geom_jitter(alpha=0.2) + facet_grid(nbedroom~.) + geom_smooth(method='lm'))

