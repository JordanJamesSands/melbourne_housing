#schools
set.seed(54378356) ; subsample = sample(1:nrow(property_data),20)
START = Sys.time()
download_osm_feature_data(df = property_data[subsample,],
                          key = 'amenity',
                          value = 'school',
                          radius = 1000,
                          dist_threshold = 500,
                          sleepdelay =  1,
                          index_range = c(1,20),
                          plot=F
                          )
print(Sys.time() - START)
