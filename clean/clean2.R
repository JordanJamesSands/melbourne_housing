#t <- select(property_data,c(nrooms,type,price,method,agent,date,precomputeddist,nbedroom,))
t <- select(property_data,-c(add,council_area))
PLOT=F
if (PLOT) {
    for (var in names(t)) {
        print(var)
        plot(property_data[[var]],property_data$price,
             col=rgb(0,0,0,0.2),
             pch=19,
             main=var
             
        )
    }
}
#------------ yearbuilt
#one item is less than 1200, set this to NA
sort(property_data$year_built) %>% head

#---------- lat/lng/computeddist, inspect in map

#----------------building_area
sort(property_data$building_area) %>% tail
mean(property_data$building_area>1000,na.rm=T)
#inverstiage further

#--------------land_area
sort(property_data$land_area) %>% tail
mean(property_data$land_area>10000,na.rm=T)
#investigate further

#------------ncar
#has some very large values
#almost unrelated to price, ignore cleaning for now

#--------------nbathroom
#dealt with in clean_with_eda

#--------------nbedroom
# drop, it is heavily correlated with nrooms

#--------------nrooms
#dealt with in clean_with_eda

#----------price
#interesting



#-----------------cleaning actions
#year_built
#1 property was apparaently built in 1196
which(property_data$year_built==1196)
#another was built in 2106
which(property_data$year_built==2106)
property_data[c(16425,2454),'year_built'] = NA

#ncars
#not a great predictor, dont clean
ncar_bool <- is.na(property_data$ncar) | property_data$ncar<=6

#building_area
if (PLOT) {
    plot(log(property_data[['building_area']]+1),log(property_data$price),col=rgb(0,0,0,0.2),pch=19)
}
#make ==0 NA
property_data[is.na(property_data$building_area) | property_data$building_area==0,'building_area'] = NA

#dropping the data is more formal
#setting to NA would be less formal, kind of making the data for myself, also, it is believable that there are large properties
prop_bool <- is.na(property_data$building_area) | property_data$building_area<1000

#land_area
if (PLOT) {
    plot(log(property_data[['land_area']]+1),log(property_data$price),col=rgb(0,0,0,0.2),pch=19)
}
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



