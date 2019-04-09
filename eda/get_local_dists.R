get_local_dists = function(lng,lat,osm_data,radius,dist_threshold,plot=T) {
    osm_locs = select(osm_data,c(lng,lat))
    dists = apply(osm_locs,1,function(lnglat) {distm(lnglat,c(lng,lat))})
    osm_locs$dist = dists
    
    #remove anything really far away before performing the clustering correction
    osm_locs = osm_locs[osm_locs$dist<(radius+dist_threshold)*1.1,]
    #cluster according to threshold
    cat(paste0(nrow(osm_locs),' points to cluster\n'))
    if(nrow(osm_locs)>1) {
        cat('Computing distance matrix...')
        dist_matrix = select(osm_locs,c(lng,lat)) %>% dist_make(distm,method='geosphere::distm')
        #dist_matrix = select(osm_locs,c(lng,lat)) %>% dist
        cat('done\n')
        clust = hclust(dist_matrix)
        clustering = cutree(clust,h=dist_threshold)
        cat(paste('points grouped into',length(unique(clustering)),'clusters\n'))
        osm_locs$cluster = clustering
    } else if (nrow(osm_locs)==1) {
        cat(paste('points grouped into 1 cluster\n'))
        osm_locs$cluster = 1
    } else {
        return(numeric(0))
    }
    cluster_locs  = group_by(osm_locs,cluster) %>% dplyr::summarise(lng=mean(lng),lat=mean(lat))
    cluster_locs$dist = select(cluster_locs,c(lng,lat)) %>% apply(1,function(x){distm(x,c(lng,lat))})
    #cull, according to radius
    cluster_locs = cluster_locs[cluster_locs$dist<radius,]

    if(plot) {
        leaflet() %>% addTiles() %>% 
            addCircles(lng=osm_locs$lng,lat=osm_locs$lat,fillColor = 'red',color='red') %>%
            addCircles(lng=cluster_locs$lng,lat=cluster_locs$lat,radius=dist_threshold) %>%
            addCircles(lng=lng,lat=lat,radius=radius,fillOpacity = 0,color='black') %>% 
            print
    }
    
    return(cluster_locs$dist)
}