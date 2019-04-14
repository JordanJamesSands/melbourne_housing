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
source('polar.R')

#read data
source('clean/read_data.R')
#clean data
source('clean/clean5.R')

#split
source('splitting_c.R')


#get osm data
source('osm_scripts/parse_osm_data_fn.R')

#then for kknn
#kknn_model_script 

#for gbdt
#basic_xgboost_post_osm




