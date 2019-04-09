#feature generation

#prep
#clear environment
rm(list=ls())

#computational time in theory grows quarticly (^4) as a fn of radius
#pars
radius=1000
dist_threshold=200
key='amenity'
value='kindergarten'
#

source('eda/download_osm_melbourne.R')
source('eda/get_local_dists.R')
#other scripts
source('project_functions.R')
#new pipeline
source('clean/read_data.R')
source('clean/clean2.R')
#get osm data



df = property_data

set.seed(3278356)
subsample = sample(1:nrow(property_data),20)
df = property_data[subsample,]


data_list=list()
osm_data = download_osm_melbourne(key,value)

START = Sys.time()
for(i in 1:nrow(df)) {
    #--------------- print progress -----------------------------------
    runtime = as.numeric(difftime(Sys.time(),START,units='secs'))/60
    estimated_runtime = runtime*nrow(df)/i
    perc_complete = round(100*(i-1)/nrow(df),2)
    cat(paste('Computing for object',i,'of',nrow(df),'\n'))
    cat(paste0('Progress: ',perc_complete,'%\n'))
    cat(paste('Total runtime =',round(runtime,2),'minutes','estimated:',
              round(estimated_runtime,2),'minutes','\n'))
    #----------------------------------------------------------
    ID = df[i,'ID']
    lng = df[i,'lng']
    lat = df[i,'lat']
    #given lng and lat, return to data_list a vector of distances
    data_list[[ID]] = get_local_dists(lng,lat,osm_data,radius,dist_threshold)
    cat('\n')
}
print(Sys.time() - START)
filename=paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
save(data_list,file=filename)

