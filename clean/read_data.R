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

#create some log transforms for area variables, this gives a slight improvement
property_data$building_area_log <- log(property_data$building_area)
property_data$land_area_log <- log(property_data$land_area +1)


#give every object an ID
property_data$ID = as.character(1:nrow(property_data))

#keep only data with price available
property_data <- property_data[!is.na(property_data$price),]