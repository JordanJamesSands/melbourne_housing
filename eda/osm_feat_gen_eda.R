set.seed(1896675)
subsample = sample(nrow(property_data),10)
download_osm_feature_data(property_data[subsample,],'shop','supermarket',3000,200,plot=T)
#200 for now

download_osm_feature_data(property_data[subsample,],'building','train_station',10000,dist_threshold=500,plot=T)
#500 is good for trains


#school 500 is good, a few cases of 1 school many dots, but also a few close calls when it comes to 2 schools 1 dot
download_osm_feature_data(property_data[subsample,],'amenity','school',5000,500,plot=T)



#kindergarten
download_osm_feature_data(property_data[subsample,],'amenity','kindergarten',5000,200,plot=T)


#park
#   leisure=dog_park
#   leisure=park
#   amenity=bbq
#maybe this will work
download_osm_feature_data(property_data[subsample,],'leisure','park',500,200,plot=T)

#dog_park this gives basically nothing
download_osm_feature_data(property_data[subsample,],'leisure','dog_park',5000,200,plot=T)

#bbq 0.1, (10cm) is good
download_osm_feature_data(property_data[subsample,],'amenity','bbq',3000,0.1,plot=T)

#amenity=cafe
download_osm_feature_data(property_data[subsample,],'amenity','cafe',2000,10,plot=T)

#amenity=bar