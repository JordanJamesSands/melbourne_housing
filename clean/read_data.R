#----read in data
property_data <- read.csv('original_data/Melbourne_housing_FULL.csv')

#----rename columns
names(property_data) <- c('suburb','add','nrooms','type','price','method','agent','date',
                          'precomputeddist','pc','nbedroom','nbathroom','ncar','land_area',
                          'building_area','year_built','council_area','lat','lng','region',
                          'propcount')

#----recast types
property_data$date = as.Date(property_data$date,format='%d/%m/%Y')
property_data$suburb = property_data$suburb %>% 
    as.character %>% capitalize %>% as.factor
property_data$add = as.character(property_data$add)
property_data$propcount = as.numeric(property_data$propcount)
property_data$precomputeddist = as.numeric(property_data$precomputeddist)

#----compute distance from city
MELBOURNE_CENTRE = c(144.9631,-37.8136)
locs = select(property_data,c(lng,lat))
property_data$dist_cbd = apply(locs,1,function(loc){distm(loc,MELBOURNE_CENTRE)})

#give every object an ID
property_data$ID = as.character(1:nrow(property_data))

#reorder columns
#property_data <- cbind(select(property_data,ID),
#                       select(property_data,-c(price,ID)),
#                       select(property_data,price)
#                       )