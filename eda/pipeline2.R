#load dependencies
require(plyr)
require(dplyr)
require(osmdata)
require(Hmisc)
require(usedist)
require(leaflet)
require(sf)
require(geosphere)
require(doParallel)
require(foreach)
require(DT)
require(plotly)
require(gsubfn)

#other scripts
source('osm_scripts/create_feat.R')
source('project_functions.R')
#read data
source('clean/read_data.R')
#clean data
source('clean/clean4.R')

#--------------------------HACK
#dim(property_data)
#property_data = property_data[!is.na(property_data$building_area),]
#dim(property_data)
#property_data = property_data[!is.na(property_data$land_area),]
#dim(property_data)
#property_data = property_data[!is.na(property_data$year_built),]
#dim(property_data)

#this seems to work much better than imputing
#maybe consider experimenting without imputing but excluding isimputed variables
#--------------------------

#split (this should not be after imputing)
source('eda/splitting_b.R')
#reconstruction
source('eda/imputing_year_b.R')
source('eda/imputing_ncar_b.R')
#source('eda/imputing_land_area_b.R')
source('eda/imputing_building_area_b.R')

#get osm data
source('osm_scripts/parse_osm_data.R')
#split train and ensemble validation
source('eda/splitting_b2.R')

