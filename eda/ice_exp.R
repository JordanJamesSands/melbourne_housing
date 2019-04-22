library(ICEbox)
prednum = which(names(train0_x)=='dist_cbd')

#######par hack?######
START = Sys.time()
#cl <- makePSOCKcluster(15)
#registerDoParallel(cl)
######################

ice_all = ice(model_all,X = as.matrix(train0_x),y = train0_y,predictor=prednum,verbose=T,frac_to_build = 0.5)
#######par hack?######
#stopCluster(cl)
print(Sys.time() - START)
######################


plot(ice_all,centered = T,colorvec = rgb((train0_x$dist_cbd>median(train0_x$dist_cbd)),0,0))

dice_all = dice(ice_all)
plot(dice_all)

#check for east/west interaction with dist
melb_long = 144.9631
#blue is east side, red is west side
plot(ice_all,centered = T,color_by=1*(train0$lng>melb_long),frac_to_plot=0.05)
#none found
