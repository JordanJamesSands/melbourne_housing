library(ICEbox)
prednum = which(names(train0_x)=='dist_cbd')
ice_all = ice(model_all,as.matrix(train0_x),train0_y,predictor=prednum,verbose=T)
plot(ice_all,centered = T)

dice_all = dice(ice_all)
plot(dice_all)

#check for east/west interaction with dist
melb_long = 144.9631
#blue is east side, red is west side
plot(ice_all,centered = T,color_by=1*(train0$lng>melb_long),frac_to_plot=0.05)
#none found
