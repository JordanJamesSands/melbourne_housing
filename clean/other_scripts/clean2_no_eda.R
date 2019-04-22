#-----------------cleaning actions

#year_built
wrong_time = which(property_data$year_built %in% c(1196,2106))
property_data[wrong_time,'year_built'] = NA

#ncars
#not a great predictor, dont clean
ncar_bool <- is.na(property_data$ncar) | property_data$ncar<=6


#building_area
#make ==0 NA
property_data[is.na(property_data$building_area) | property_data$building_area==0,'building_area'] = NA

#dropping the data is more formal
#setting to NA would be less formal, kind of making the data for myself, also, it is believable that there are large properties
prop_bool <- is.na(property_data$building_area) | property_data$building_area<1000


#land_area
#make ==0 NA
property_data[is.na(property_data$land_area) | property_data$land_area==0,'land_area'] = NA
land_bool <- is.na(property_data$land_area) | property_data$land_area < 10000


#gather bools of which rows can be kept, intersection will be kept
bath_bool <- is.na(property_data$nbathroom) | (property_data$nbathroom<=4 & property_data$nbathroom>0)
nroom_bool <- is.na(property_data$nrooms) | (property_data$nrooms<=6 & property_data$nrooms>0)


#keep intersection
property_data <- property_data[nroom_bool & bath_bool & land_bool & prop_bool & ncar_bool,]


#drop anything with nbathroom na, explained in clean_with_eda
#lng and lat have very few missing, dont wanna bother imputing
drop_rows <- is.na(property_data$nbathroom) | is.na(property_data$lng) | is.na(property_data$lat)
property_data <- property_data[!drop_rows,]



