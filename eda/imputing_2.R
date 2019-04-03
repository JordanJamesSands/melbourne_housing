library(dplyr)
library(RColorBrewer)
library(Hmisc)

tmp <- property_data %>% select(c(date,nrooms,type,nbathroom,ncar,suburb,price,method,
                                  land_area,building_area,year_built,lat,lng,region))
sapply(tmp,function(col){mean(!is.na(col))})
sapply(tmp,function(col){sum(is.na(col))})


#year_built
pal <- brewer.pal(9,'BrBG')
d <- train0_impyear
d$year_color = cut2(d$year_built,g=9)
levels(d$year_color) = pal
d$year_color = as.character(d$year_color)

par(bg='black')
with(d,
     plot(lng,lat,col=year_color,pch=19,cex=0.1)
     )


#building_area
#land_area
#ncar