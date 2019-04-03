library(dplyr)
library(Hmisc)
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

#property_data$suburb = tolower(property_data$suburb)
#property_data$suburb= lapply(clean_suburb_names(property_data$suburb),toString)
property_data$suburb = capitalize(property_data$suburb)
property_data$suburb = as.factor(property_data$suburb)
property_data$method = as.factor(property_data$method)
property_data$region = as.factor(property_data$region)
property_data$agent = as.factor(property_data$agent)
property_data$propcount = as.numeric(property_data$propcount)
property_data$precomputeddist = as.numeric(property_data$precomputeddist)

clean_suburb_names <- function(suburbs) {
    
}



#clean_suburb_names <- function(suburbs) {
#    lapply(strsplit(tolower(suburbs),' '),function(x){
#        paste0(toupper(substring(x,1,1)),substring(x,2))
#        })
#}

#adjust lng and lat to centre of melbourne, (as defined by google)
#LNG_CENTRE = 144.9631
#LAT_CENTRE = -37.8136
#property_data$lng = property_data$lng - LNG_CENTRE
#property_data$lat = property_data$lat - LAT_CENTRE



