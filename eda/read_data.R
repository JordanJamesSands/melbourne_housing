library(dplyr)
#read in data
d <- read.csv('original_data/Melbourne_housing_FULL.csv',stringsAsFactors = FALSE)
#rename columns
names(d) <- c('suburb','add','nrooms','type','price','method','agent','date',
              'precomputeddist','pc','nbedroom','nbathroom','ncar','land_area',
              'building_area','year_built','council_area','lat','lng','region',
              'propcount')
#dont remove entries without price yet, use them to reconstruct data

#parse columns
d$date = as.Date(d$date,format='%d/%m/%Y')
d$type = as.factor(d$type)
d$suburb = tolower(d$suburb)
d$suburb = as.factor(d$suburb)
d$method = as.factor(d$method)
d$region = as.factor(d$region)
property_data = d


#For initial eda, subset interesting columns
t <- d %>% select(date,nrooms,type,nbedroom,nbathroom,ncar,suburb,price,method,
            land_area,building_area,year_built,lat,lng,region
            ) 
