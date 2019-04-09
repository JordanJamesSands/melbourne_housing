#download feat data

nthreads = 3

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

#other scripts
source('project_functions.R')
source('clean/read_data.R')
source('clean/clean2.R')
source('osm_scripts/download_local_features_parallel_fun.R')

#hack for testing
set.seed(54378356) ; subsample = sample(1:nrow(property_data),1000)
property_data = property_data[subsample,]
#

start_script=Sys.time()
#begin
start = Sys.time()
cat(paste('downloading data for schools\n'))
out = download_local_feats_par_fun(property_data,'amenity','school',2000,500,nthreads = nthreads)
print(Sys.time() - start)
#

start = Sys.time()
cat(paste('downloading data for trains\n'))
out = download_local_feats_par_fun(property_data,'building','train_station',2000,500,nthreads = nthreads)
print(Sys.time() - start)
#

start = Sys.time()
cat(paste('downloading data for supermarkets\n'))
out = download_local_feats_par_fun(property_data,'shop','supermarket',1000,100,nthreads = nthreads)
print(Sys.time() - start)
#

start = Sys.time()
cat(paste('downloading data for supermarkets\n'))
out = download_local_feats_par_fun(property_data,'amenity','kindergarten',1000,100,nthreads = nthreads)
print(Sys.time() - start)
#

start = Sys.time()
cat(paste('downloading data for supermarkets\n'))
out = download_local_feats_par_fun(property_data,'leisure','dog_park',1000,300,nthreads = nthreads)
print(Sys.time() - start)
#

start = Sys.time()
cat(paste('downloading data for supermarkets\n'))
out = download_local_feats_par_fun(property_data,'amenity','bbq',1000,0.1,nthreads = nthreads)
print(Sys.time() - start)
#

start = Sys.time()
cat(paste('downloading data for supermarkets\n'))
out = download_local_feats_par_fun(property_data,'amenity','cafe',1000,30,nthreads = nthreads)
print(Sys.time() - start)
#

start = Sys.time()
cat(paste('downloading data for supermarkets\n'))
out = download_local_feats_par_fun(property_data,'amenity','bar',1000,30,nthreads = nthreads)
print(Sys.time() - start)
#

cat('Total script: ')
print(Sys.time() - start_script)
