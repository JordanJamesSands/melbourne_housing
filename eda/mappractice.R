library(leaflet)
#plot data points
leaflet(d) %>% addTiles() %>% addCircles(lat=~lat,lng=~lng)
#plot localites
locs <-  readOGR('other_data/VIC_LOCALITY_POLYGON_shp.shp',GDAL1_integer64_policy = TRUE)
#locs$VIC_LOCA_2 has suburb names
leaflet(localities) %>% addTiles() %>%  addPolygons(fill=FALSE)
