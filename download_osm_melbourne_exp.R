testlocs = data.frame(lng=c(),lat=c())
MAX_EAST = 145.8
MAX_WEST = 144.2
MAX_NORTH = -37.2
MAX_SOUTH = -38.5

testlocs = rbind(testlocs,c(MAX_WEST,MAX_NORTH))
testlocs = rbind(testlocs,c(MAX_WEST,MAX_SOUTH))
testlocs = rbind(testlocs,c(MAX_EAST,MAX_NORTH))
testlocs = rbind(testlocs,c(MAX_EAST,MAX_SOUTH))

#> min(property_data$lng)
#[1] 144.4238
#> min(property_data$lat)
#[1] -38.19043
#> max(property_data$lat)
#[1] -37.3951
#> max(property_data$lng)
#[1] 145.5264

names(testlocs) = c('lng','lat')

#leaflet() %>% addTiles() %>% addMarkers(lng=testlocs$lng,lat=testlocs$lat)


mat = matrix(c(144,-38.5,146,-37.2),nrow=2)
rownames(mat) <- c('x','y')
colnames(mat) <- c('min','max')

query = opq(mat) %>% add_osm_feature('amenity','school')

d <- osmdata_sf(query)
locs = as.data.frame(st_coordinates(d$osm_points$geometry))
names(locs) = c('lng','lat')

outer = property_data[property_data$dist_cbd>20000,]


leaflet() %>% addTiles() %>% addCircles(lng=locs$lng,lat=locs$lat)
#leaflet() %>% addTiles() %>% addCircles(lng=outer$lng,lat=outer$lat,radius=10000) %>%
    addMarkers(lng=testlocs$lng,lat=testlocs$lat)
