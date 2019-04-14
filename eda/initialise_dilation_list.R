#xgb_fi <- xgb.importance(feature_names= names(train0_x),model=model_all)
#xgb.plot.importance(xgb_fi,measure='Gain')
#xgb_gain <- select(xgb_fi,c(Feature,Gain))
#xgb_gain$inv_gain <- 1/xgb_gain$Gain
#xgb_gain



dilation_list = c(                      
    building_area=1,
    lat=0.1,
    lng=0.00001,
    year_built=1e+9,
    type_encoded=1e+9,
    nrooms=1e+9,
    land_area=7,
    nbathroom=2,
    propcount=1e+9,
    ncar=0.0001
    #dist_cbd=1000,
)


#dilation_vec <- xgb_gain$inv_gain
#names(dilation_vec) <- xgb_gain$Feature
#print(dilation_vec)
#dilation_list = list()
#for(featname in names(dilation_vec)) {
#    dilation_list[[featname]] = dilation_vec[names(dilation_vec) == featname]
#}

#
#
#
#
#
#
#