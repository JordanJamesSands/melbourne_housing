dist_matrix = dist_make(locs,distm,method='geosphere::distm')

clust = hclust(dist_matrix)
DIST_THRESHOLD=200
#if 2 objects are within DIST_THRESHOLD, treat them as the same?
clustering = cutree(clust,h=DIST_THRESHOLD)
length(unique(clustering))
locs$cluster = clustering
cluster_locs  = group_by(locs,cluster) %>% summarise(lng=mean(lng),lat=mean(lat))

leaflet() %>% addTiles() %>% 
    addCircles(lng=cluster_locs$lng,lat=cluster_locs$lat,
               radius=50,
               fillOpacity = 0.5
               ) %>% 
    addCircles(lng=locs$lng,lat=locs$lat,
               fillColor ='red',
               fillOpacity = 0.5,
               color='red',
               opacity = 0.5
               )
