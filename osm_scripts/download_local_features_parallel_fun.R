
#pars
#radius=1000
#dist_threshold=500
#key='amenity'
#value='school'

#df = property_data
#

source('osm_scripts/download_osm_melbourne.R')
require(stringr)
download_local_feats_par_fun <- function(df,key,value,radius,dist_threshold,nthreads,plot=F) {
    #prepare parallel compute
    cl <- makeCluster(nthreads)
    registerDoParallel(cl)
    
    #download osm data
    osm_data = download_osm_melbourne(key,value,plot = F)
    
    data_list <- foreach(i = 1:nrow(df) , .packages=c('plyr','dplyr','geosphere','usedist','leaflet')) %dopar% {
        source('osm_scripts/get_local_dists.R')
        ID = df[i,'ID']
        lng = df[i,'lng']
        lat = df[i,'lat']
        local_data = get_local_dists(lng,lat,osm_data,radius,dist_threshold,plot=plot)
        list('ID'=ID,'dists'=local_data$dists,'plot'=local_data$plot)
    }
    
    stopCluster(cl)
    now=str_replace_all(as.character(Sys.time()),':','.')
    filename=paste0('gen_data/local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold,'_',now)
    save(data_list,file=filename)
}