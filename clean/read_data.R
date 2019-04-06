library(dplyr)
library(Hmisc)
library(geosphere)
#read in data
property_data <- read.csv('original_data/Melbourne_housing_FULL.csv',stringsAsFactors = FALSE)
dim(property_data)
#rename columns
names(property_data) <- c('suburb','add','nrooms','type','price','method','agent','date',
              'precomputeddist','pc','nbedroom','nbathroom','ncar','land_area',
              'building_area','year_built','council_area','lat','lng','region',
              'propcount')
#dont remove entries without price yet, use them to reconstruct data

#parse columns
property_data$date = as.Date(property_data$date,format='%d/%m/%Y')
property_data$type = as.factor(property_data$type)


property_data$suburb = capitalize(property_data$suburb)
property_data$suburb = as.factor(property_data$suburb)
property_data$method = as.factor(property_data$method)
property_data$region = as.factor(property_data$region)
property_data$agent = as.factor(property_data$agent)
property_data$propcount = as.numeric(property_data$propcount)
property_data$precomputeddist = as.numeric(property_data$precomputeddist)

#compute distance from city
MELBOURNE_CENTRE = c(144.9631,-37.8136)
locs = select(property_data,c(lng,lat))
property_data$dist_cbd = apply(locs,1,function(loc){distm(loc,MELBOURNE_CENTRE)})
#eda
#loc_cc = complete.cases(select(property_data,c(dist_cbd,precomputeddist)))
#cor(property_data$precomputeddist[loc_cc],property_data$dist_cbd[loc_cc])
#plot(property_data$precomputeddist,property_data$dist_cbd)

#give every object an ID
property_data$ID = as.character(1:nrow(property_data))

