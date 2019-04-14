#other scripts
source('project_functions.R')
#new pipeline
source('clean/read_data.R')
source('clean/clean2.R')

sdf = n_neighbours(osm_data$school,2000,'nschools_2000')
newdata = merge(property_data,sdf,by='ID')
newdata = merge(newdata,min_dist(osm_data$train,1,'traindist',1000),by='ID')
newdata = merge(newdata,n_neighbours(osm_data$supermarket,1000,'nsuper_1000'),by='ID')
newdata = merge(newdata,n_neighbours(osm_data$bbq,1000,'nbbq_1000'),by='ID')

s = newdata[newdata$traindist<1000,]
plot(jitter(s$traindist,2),log(s$price),pch=19,col=rgb(0,0,0,0.2))

plot(jitter(newdata$nbbq_1000,2),log(newdata$price),pch=19,col=rgb(0,0,0,0.2),xlim=c(0,10))
plot(jitter(newdata$nsuper_1000,2),log(newdata$price),pch=19,col=rgb(0,0,0,0.2))
plot(newdata$traindist,log(newdata$price),pch=19,col=rgb(0,0,0,0.2))
plot(jitter(newdata$nschools_2000,2),log(newdata$price),pch=19,col=rgb(0,0,0,0.2))

lm(log(price) ~ nschools_2000,data=newdata) %>% summary
lm(log(price) ~ nbbq_1000,data=newdata) %>% summary



source('eda/imputing_year.R')
source('eda/imputing_ncar.R')
source('eda/imputing_land_area.R')
source('eda/imputing_building_area.R')
source('eda/splitting.R')
source('eda/splitting0.R')

newdata = merge(property_data,sdf,by='ID')
newdata = merge(newdata,n_neighbours(osm_data$bbq,1000,'nbbq_1000'),by='ID')


cor(newdata$nschools_2000,log(newdata$price))
cor(newdata$nbbq_1000,log(newdata$price))

