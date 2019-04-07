#feature generation

#pars
radius=3000
dist_threshold=200
#
START = Sys.time()

subsample = sample(1:nrow(property_data),10)
df = property_data[subsample,]
data_list=list()
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
    dist_matrix = select(locs,c(lng,lat)) %>% dist_make(distm,method='geosphere::distm')
    clust = hclust(dist_matrix)
    clustering = cutree(clust,h=dist_threshold)
    cat(paste('points grouped into',length(unique(clustering)),'clusters\n'))
    locs$cluster = clustering
    cluster_locs  = group_by(locs,cluster) %>% dplyr::summarise(lng=mean(lng),lat=mean(lat))
    cluster_locs$dist = select(cluster_locs,c(lng,lat)) %>% apply(1,function(x){distm(x,c(lng,lat))})
    #cull, according to radius
    cluster_locs = cluster_locs[cluster_locs$dist<radius,]
    cluster_locs = select(cluster_locs,-cluster)
    data_list[[ID]] = cluster_locs
}
print(Sys.time() - START)
