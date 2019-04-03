library(RgoogleMaps)
library(RColorBrewer)

#univariate
plot(log(train0$land_area),pch=19,col=rgb(0,0,0,0.2))
#with price
plot(log(train0$price),log(train0$land_area),pch=19,col=rgb(0,0,0,0.2))
plot(log(train0$land_area),log(train0$price),pch=19,col=rgb(0,0,0,0.2))

pal0 <- brewer.pal(3,'Set1')
pal <- AddAlpha(pal0,0.2)

plot(log(train0$land_area),pch=19,col=pal[as.numeric(train0$type)])
legend( 'bottomleft',legend = c('house','unit','townhouse'),fill = pal0)
qplot(x=train0$type,y=log(train0$land_area),geom = 'violin',fill = train0$type)
plot(jitter(as.numeric(train0$type),2),log(train0$land_area),pch=19,col=pal[as.numeric(train0$type)])



#other vars
plot(train0$nrooms,log(train0$land_area),pch=19,col=rgb(0,0,0,0.2))
plot(train0$year_built,log(train0$land_area),pch=19,col=pal[as.numeric(train0$type)])

mod1 <- lm(log(land_area) ~ nrooms + type + 
              precomputeddist + nbedroom + nbathroom + ncar + 
              year_built + lat + lng + region + propcount
          ,data=train0)

mod2 <- lm(log(land_area) ~ nrooms + type + 
              precomputeddist  + nbathroom + ncar + 
              year_built + lat + lng
          ,data=train0)

mod3 <- lm(log(land_area) ~ nrooms + type + 
              precomputeddist  + nbathroom + ncar + 
              year_built
          ,data=train0)

mod4 <- lm(log(land_area) ~ factor(nrooms) + type 
           ,data=train0)

plot(jitter(train0$nrooms,2),log(train0$land_area))
plot(jitter(train0$ncar,2),log(train0$land_area))
plot(jitter(train0$nbathroom,2),log(train0$land_area))

plot(jitter(as.numeric(train0$type),2),log(train0$land_area),pch=19,col=pal[as.numeric(train0$type)])
plot(train0$lat,log(train0$land_area))
plot(train0$lng,log(train0$land_area))
plot(train0$precomputeddist,log(train0$land_area))

with(train0,plot(precomputeddist,log(land_area),pch=19,col=rgb(0,0,0,.2)))

