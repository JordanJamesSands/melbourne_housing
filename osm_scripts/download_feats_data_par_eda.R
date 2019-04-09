nthreads=3

set.seed(453607)
subsample = sample(1:nrow(property_data),6)

#trains (done)
key='building'
value='train_station'
radius=4000
dist_threshold=500

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------

#schools (done)
key='amenity'
value='school'
radius=2000
dist_threshold=500

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------

#supermarket (good enough?)
key='shop'
value='supermarket'
radius=2000
dist_threshold=100

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------



#kindergaretn (done)
key='amenity'
value='kindergarten'
radius=2000
dist_threshold=100

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------

#park, dont use
key='leisure'
value='park'
radius=500
dist_threshold=200

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------

#dog_park (done)
key='leisure'
value='dog_park'
radius=4000
dist_threshold=300

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------

#bbq (done)
key='amenity'
value='bbq'
radius=4000
dist_threshold=0.1

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------

#cefe (done)
key='amenity'
value='cafe'
radius=4000
dist_threshold=30

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------


# bar (done)
key='amenity'
value='bar'
radius=4000
dist_threshold=30

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list

download_local_feats_par_fun(data.frame(lng=melb_lng,lat=melb_lat),key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------


#
key=''
value=''
radius=4000
dist_threshold=500

#get data and plot
out = download_local_feats_par_fun(property_data[subsample,],key,value,radius,dist_threshold,nthreads = nthreads,plot=T)
filename = paste0('local_data_','key=',key,'_value=',value,'_radius=',radius,'_dist_threshold=',dist_threshold)
load(filename,verbose=T)
data_list
#-------------------
