library(Hmisc)
library(rgdal)
melb <- getbb('Melbourne')
bounds <-  readOGR('other_data/VIC_LOCALITY_POLYGON_shp.shp',GDAL1_integer64_policy = TRUE,stringsAsFactors = F)
bounds$VIC_LOCA_2 <- capitalize(tolower(bounds$VIC_LOCA_2))

kew_bounds = bounds[bounds$VIC_LOCA_2=='Kew',]
#kew_central = c(-37.8053, 145.0358)
kew_bb = bbox(kew_bounds)

#
#q = add_osm_feature(opq(kew_bb),'leisure','park')
q = add_osm_feature(opq(kew_bb),'amenity','school')
#q = add_osm_feature(opq(kew_bb),'shop','supermarket')
#q = add_osm_feature(opq(kew_bb),'building','school')
#q = add_osm_feature(opq(kew_bb),'building','kindergarten')
#q = add_osm_feature(opq(kew_bb),'amenity','kindergarten')



d <- osmdata_sf(q)
names = d$osm_points$name
locs = as.data.frame(st_coordinates(d$osm_points$geometry))
names(locs) = c('lng','lat')

#
#feats = available_features()

#leaflet(select(locs,c(lng,lat))) #%>% addTiles()
leaflet() %>% addTiles() %>% addCircles(lng=locs$lng,lat=locs$lat)

