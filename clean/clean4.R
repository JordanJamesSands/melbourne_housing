#script to explore and clean data, per feature


#NOTES:
#reconsider settingland_area==0 to NA
#consider hardcoding dropping nans on vars that I have since decided not to impute

#----------------------lnglat
leaflet(property_data) %>% addTiles %>% addCircles(lng=~lng,lat=~lat,
                                                   opacity = 0.5,
                                                   fillOpacity = 0.5)

#lng and lat have very few missing, dont wanna bother imputing
loc_bool <- !is.na(property_data$lng) & !(is.na(property_data$lat))
#----------------------year_built
qplot(data=property_data,y=year_built,xlab='index')
#1 property was apparaently built in 1196 and another next century

to_correct = which(property_data$year_built > 2030| property_data$year_built < 1788) 
property_data[to_correct,'year_built'] = NA

#--------------------ncar
qplot(data=property_data,x=ncar,y=log(price),geom='jitter',alpha=0.1)
#limit the scope of analysis to properties with fewer than 7 car parks
ncar_bool <- is.na(property_data$ncar) | property_data$ncar<=6

#--------------------nbathroom
qplot(data=property_data,x=nbathroom,y=log(price),geom='jitter',alpha=0.1)
#limit the analysis to properties with nbathroom <= 4
bath_bool <- !is.na(property_data$nbathroom) & (property_data$nbathroom<=4 & property_data$nbathroom>0)

#---------------------nrooms
qplot(data=property_data,x=nrooms,y=log(price),geom='jitter',alpha=0.1)
#limit the analysis to properties with nrooms <=6
nroom_bool <- property_data$nrooms<=6 & property_data$nrooms>0

#---------------------nbedroom
sum(is.na(property_data$nbedroom))
has_bedroom = !is.na(property_data$nbedroom)
cor(property_data$nbedroom[has_bedroom],property_data$nrooms[has_bedroom])
#dont include in analysis

#----------------------building_area
qplot(data=property_data,x=building_area,y=log(price),alpha=0.1,geom='point')
#make ==0 NA
property_data[is.na(property_data$building_area) | property_data$building_area==0,'building_area'] = NA


#limit analysis to buildings with less than 1000 building_area
BA_bool <- is.na(property_data$building_area) | property_data$building_area<1000

#----------------------land_area
qplot(data=property_data,x=land_area,y=log(price),alpha=0.1,geom='point')
#make ==0 NA
#property_data[is.na(property_data$land_area) | property_data$land_area==0,'land_area'] = NA

#limit analysis to properties with land_area < 10000
land_bool <- is.na(property_data$land_area) | property_data$land_area < 10000

#---------------------actions

#gather bools of which rows can be kept, intersection will be kept
property_data <- property_data[nroom_bool & bath_bool & land_bool & BA_bool & ncar_bool &loc_bool,]

#replot
qplot(data=property_data,x=building_area,y=log(price),alpha=0.1,geom='point')
qplot(data=property_data,x=land_area,y=log(price),alpha=0.1,geom='point')
