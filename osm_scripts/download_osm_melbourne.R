download_osm_melbourne <- function(key,value,plot=T) {
    MAX_EAST = 145.8
    MAX_WEST = 144.2
    MAX_NORTH = -37.2
    MAX_SOUTH = -38.5
    
    #create bbox
    mat = matrix(c(MAX_WEST,MAX_SOUTH,MAX_EAST,MAX_NORTH),nrow=2)
    rownames(mat) <- c('x','y')
    colnames(mat) <- c('min','max')
    
    #setup query
    query = opq(mat) %>% add_osm_feature(key,value)
    d <- osmdata_sf(query)
    req_data = as.data.frame(st_coordinates(d$osm_points$geometry))
    
    names(req_data) = c('lng','lat')

    
    if (plot) {
        markers = data.frame(lng=c(MAX_EAST,MAX_EAST,MAX_WEST,MAX_WEST),
                             lat=c(MAX_NORTH,MAX_SOUTH,MAX_NORTH,MAX_SOUTH))
        names(markers) = c('lng','lat')
        
        leaflet() %>% addTiles() %>% addCircles(lng=req_data$lng,lat=req_data$lat) %>% 
            addMarkers(lng=markers$lng,lat=markers$lat) %>%
            print
    }

    return(req_data)
}
