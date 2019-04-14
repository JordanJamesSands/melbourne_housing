#load dependencies
require(plyr)
require(dplyr)      #for manipulating data frames
require(osmdata)    #for downloading data from Open Street Map
require(Hmisc)      
require(usedist)
require(leaflet)
require(sf)
require(geosphere)
require(doParallel)
require(foreach)
require(DT)
require(plotly)
require(caret)
require(xgboost)
require(pdp)
require(vip)
require(gsubfn)
require(ICEbox)

#other scripts
source('project_functions.R')
source('osm_scripts/create_feat.R')
#read data
source('clean/read_data.R')
#clean data
source('clean/clean2.R')
#reconstruction
source('eda/imputing_year.R')
source('eda/imputing_ncar.R')
source('eda/imputing_land_area.R')
source('eda/imputing_building_area.R')
#get osm data
source('osm_scripts/parse_osm_data.R')
#split
source('eda/splitting.R')
source('eda/splitting0.R')
#modelling


