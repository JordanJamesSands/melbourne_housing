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

#other scripts
source('project_functions.R')
#new pipeline
source('clean/read_data.R')
source('clean/clean2.R')
#get osm data
source('eda/imputing_year.R')
source('eda/imputing_ncar.R')
source('eda/imputing_land_area.R')
source('eda/imputing_building_area.R')
source('eda/splitting.R')
source('eda/splitting0.R')
