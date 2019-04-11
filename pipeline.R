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

#other scripts
source('project_functions.R')
#read data
source('clean/read_data.R')
#clean data
source('clean/clean2.R')
#split (this should not be after imputing)
source('eda/splitting.R')
#reconstruction
source('eda/imputing_year.R')
source('eda/imputing_ncar.R')
source('eda/imputing_land_area.R')
source('eda/imputing_building_area.R')
#get osm data
source('osm_scripts/parse_osm_data.R')

source('eda/splitting0.R')

