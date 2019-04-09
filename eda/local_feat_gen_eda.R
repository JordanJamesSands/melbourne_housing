#feature generation

#prep
#clear environment
rm(list=ls())

source('eda/download_osm_melbourne.R')
#other scripts
source('project_functions.R')
#new pipeline
source('clean/read_data.R')
source('clean/clean2.R')
#get osm data

#pars
radius=300
dist_threshold=200
key='amenity'
value='school'
#
START = Sys.time()

#subsample = sample(1:nrow(property_data),10)
#df = property_data[subsample,]

df = property_data
data_list=list()
osm_data = download_osm_melbourne(key,value)

for(i in 1:nrow(df)) {
    ID = df[i,'ID']
    lng = df[i,'lng']
    lat = df[i,'lat']
    
    
    locs = select(osm_data,c(lng,lat))
    dists = apply(locs,1,function(lnglat) {distm(lnglat,c(lng,lat))})
    locs$dist = dists
    #remove anything really far away before performing the clustering correction
    locs = locs[locs$dist<(radius+dist_threshold)*1.1,]
    
    #cluster according to threshold
    cat(paste0(nrow(locs),' points to cluster\n'))
    if(nrow(locs)>1) {
        dist_matrix = select(locs,c(lng,lat)) %>% dist_make(distm,method='geosphere::distm')
        clust = hclust(dist_matrix)
        clustering = cutree(clust,h=dist_threshold)
        cat(paste('points grouped into',length(unique(clustering)),'clusters\n'))
        locs$cluster = clustering
    } else if (nrow(locs)==1) {
        locs$cluster = 1
    } else {
        
    }
    cluster_locs  = group_by(locs,cluster) %>% dplyr::summarise(lng=mean(lng),lat=mean(lat))
    cluster_locs$dist = select(cluster_locs,c(lng,lat)) %>% apply(1,function(x){distm(x,c(lng,lat))})
    #cull, according to radius
    cluster_locs = cluster_locs[cluster_locs$dist<radius,]
    cluster_locs = select(cluster_locs,-cluster)
    data_list[[ID]] = cluster_locs
}
print(Sys.time() - START)
filename=paste0('')

