library(dplyr)
#read in data
dl <- read.csv('original_data/MELBOURNE_HOUSE_PRICES_LESS.csv',stringsAsFactors = FALSE)
#rename columns
names(dl) <- c('suburb','add','nrooms','type','price','method','agent','date','pc','region','propcount','precomputeddist','coucil_area')
#names(dl) <- c('suburb','add','nrooms','type','price','method','agent','date',
#              'precomputeddist','pc','nbedroom','nbathroom','ncar','land_area',
#              'building_area','year_built','council_area','lat','lng','region',
#              'propcount')

dl$date = as.Date(dl$date,format='%d/%m/%Y')
dl$type = as.factor(dl$type)
dl$suburb = as.factor(dl$suburb)
dl$method = as.factor(dl$method)
dl$region = as.factor(dl$region)

#For initial eda, subset interesting columns
tl <- dl %>% select(date,nrooms,type,suburb,price,method,region
) 
