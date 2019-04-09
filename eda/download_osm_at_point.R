download_osm_at_point <- function(lng,lat,key,value,radius,dist_threshold,plot=FALSE) {
    #call 
    bounding_box = calculate_bounding_box(lng,lat,radius,dist_threshold)
    query = opq(bounding_box) %>% add_osm_feature(key,value)
    
    #parse data in to lng lat
    d <- osmdata_sf(query)
    names = d$osm_points$name
    if (is.null(d$osm_points$geometry)) {
        return(numeric(0))
        }
    else {
        locs = as.data.frame(st_coordinates(d$osm_points$geometry))
        }
    
    names(locs) = c('lng','lat')
    

    if (nrow(locs)>1) {
        dist_matrix = dist_make(locs,distm,method='geosphere::distm')
        clust = hclust(dist_matrix)
        clustering = cutree(clust,h=dist_threshold)
        cat(paste('points grouped into',length(unique(clustering)),'clusters\n'))
        locs$cluster = clustering
        
    } else {
        locs$cluster = 1 
    }
    cluster_locs  = group_by(locs,cluster) %>% dplyr::summarise(lng=mean(lng),lat=mean(lat))
    
    #drop objects too far away
    cluster_locs$dist = select(cluster_locs,c(lng,lat)) %>% apply(1,function(x){distm(x,c(lng,lat))})
    #print(cluster_locs)
    cluster_locs = cluster_locs[cluster_locs$dist<radius,]
    cluster_locs = cluster_locs[order(cluster_locs$dist),]
    if(plot) {
        plot = leaflet() %>% addTiles() %>% 
            addCircles(lng=cluster_locs$lng,lat=cluster_locs$lat,
                       radius=dist_threshold,
                       fillOpacity = 0.5
            ) %>% 
            addCircles(lng=locs$lng,lat=locs$lat,
                       fillColor ='red',
                       fillOpacity = 0.5,
                       color='red',
                       opacity = 0.5
            ) %>%
            addCircles(lng=lng,lat=lat,
                       radius=radius,
                       weight=1,
                       fillColor='black',
                       fillOpacity = 0.0,
                       color='black',
                       opacity=0.8
        )
        print(plot)
    }
    return(cluster_locs$dist)
}

calculate_bounding_box <- function(lng,lat,radius,dist_threshold) {
    #set search dist a little larger in case we get half of a compound,
    #later the results are filtered by distance anyway
    search_dist = (radius+dist_threshold)*1.1
    
    east_boundary = destPoint(c(lng,lat),90,search_dist)[1,1]
    north_boundary = destPoint(c(lng,lat),0,search_dist)[1,2]
    south_boundary = destPoint(c(lng,lat),180,search_dist)[1,2]
    west_boundary = destPoint(c(lng,lat),270,search_dist)[1,1]
    
    #mat = matrix(c(west_boundary,north_boundary,east_boundary,south_boundary),nrow=2)
    mat = matrix(c(west_boundary,south_boundary,east_boundary,north_boundary),nrow=2)
    rownames(mat) <- c('x','y')
    colnames(mat) <- c('min','max')
    return(mat)
    
}
