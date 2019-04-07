#schools
download_osm_feature_data(df = property_data,
                          key = 'amenity',
                          value = 'school',
                          radius = 300,
                          dist_threshold = 500,
                          sleepdelay =  1,
                          index_range = c(1,5),
                          plot=F
                          )
