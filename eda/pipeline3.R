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
require(caret)

#other scripts
source('osm_scripts/create_feat.R')
source('project_functions.R')

#read data
source('clean/read_data.R')
#clean data
source('clean/clean5.R')
#split
source('eda/splitting_b.R')

id_order <- property_data$ID
#get osm data
source('osm_scripts/parse_osm_data_script.R') #this jumbles!

#split train and ensemble validation
source('eda/splitting_b2.R')
