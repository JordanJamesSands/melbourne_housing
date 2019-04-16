#load dependencies
require(tidyr)
require(plyr)
require(dplyr)
require(osmdata)
require(Hmisc)
require(usedist)
require(leaflet)
require(sf)
require(rgdal)
require(htmltools)
require(xgboost)
require(geosphere)
require(doParallel)
require(foreach)
require(DT)
require(plotly)
require(gsubfn)
require(caret)
require(gam)

#other scripts
source('osm_scripts/create_feat.R')
source('project_functions.R')
source('polar.R')

#read data
source('clean/read_data.R')
#clean data
source('clean/clean5.R')

#not_sold <- property_data$method %in% c('PI','NB','VB','W')
#property_data <- property_data[!not_sold,]


#HACK, drop crazy prices, this will change the train test split!
#to_drop_id <- c("3291" , "19584")
#to_drop_index <- (property_data$ID %in% to_drop_id) %>% which
#property_data <- property_data[-to_drop_index,]

#split
source('splitting_c.R')

#get osm data
source('osm_scripts/parse_osm_data_fn.R')

#then for kknn
source('kknn_report.R')

#for gbdt
source('xgboost_report.R')

#gam
source('gam_report.R')

#ensemble
source('ensemble.R')
source('testing.R')





