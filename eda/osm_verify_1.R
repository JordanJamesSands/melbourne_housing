b1 = property_data$school_min_dist<2000
b2 = property_data$nschool_2000 > 0
mean(b1==b2)
s = which(b1!=b2)
d = property_data[s,c('ID','school_min_dist','nschool_2000')]
head(d)

ind = which(property_data$ID==11122)
property_data[ind,c('ID','lng','lat')]
download_local_feats_par_fun(property_data[ind,c('ID','lng','lat')],'amenity','school',2000,500,1,plot=T)
#load('gen_data/local_data_key=amenity_value=school_radius=2000_dist_threshold=500')
#data_list
