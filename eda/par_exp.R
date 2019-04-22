#######par hack?######
START = Sys.time()
cl <- makeCluster(10)
registerDoParallel(cl)
######################

#prednum = which(names(xgb_train0_x)=='dist_cbd')
ice_obj = ice(model_all,X = as.matrix(xgb_train0_x),y = xgb_train0_y,predictor=prednum,verbose=T,num_grid_pts = 60,frac_to_build = 0.5)
plot(ice_obj)

partial(model_all,
        'dist_cbd',
        ice=T,
        plot=T,
#        plot.engine = 'ggplot2',
        parallel = T,
        paropts = list(.packages = (.packages())),
#        paropts = list(.packages = 'xgboost'),
        #alpha=0.1,
        grid.resolution = GRID_RES
        #alpha=1,
        #grid.resolution = 50

        
)



#######par hack?######
stopCluster(cl)
print(Sys.time() - START)
######################

