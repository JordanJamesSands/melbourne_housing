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
require(knitr)

#other scripts
source('osm_scripts/create_feat.R')
source('project_functions.R')
source('clean/polar.R')

#read data
source('clean/read_data.R')
#clean data
source('clean/clean5.R')

#split
source('clean/splitting.R')

#get osm data
source('osm_scripts/parse_osm_data_fn.R')

#then for kknn
source('model_scripts/kknn_report.R')

#for gbdt
source('model_scripts/xgboost_report.R')

#gam
source('model_scripts/gam_report.R')

#ensemble
source('model_scripts/ensemble.R')





