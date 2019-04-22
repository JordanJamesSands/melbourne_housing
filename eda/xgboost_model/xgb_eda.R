#-------------------------pdp---------------------------------------------------
#hack becuase cgboost passes data to xgb.train
dtrain = as.matrix(xgb_train0_x)
GRID_RES = 100
for(var in names(xgb_train0_x)) {
    print(var)
    #create pdp
    partial(model_all,
            var,
            ice=T,
            plot=T,
            plot.engine = 'ggplot2',
            alpha=0.1,
            grid.resolution = GRID_RES
            ) %>% print
}

ice_data <- partial(model_all,'dist_cbd',ice=T)
ggplot(data=ice_data,aes(x=dist_cbd,y=yhat,group=yhat.id)) + geom_line(alpha=0.1)

partial(model_all,'dist_cbd',ice=T,plot=T,plot.engine = 'ggplot2',alpha=0.1) %>% print


START = Sys.time()
prednum = which(names(xgb_train0_x)=='dist_cbd')
ice_obj = ice(model_all,X = as.matrix(xgb_train0_x),y = xgb_train0_y,predictor=prednum,verbose=T,num_grid_pts = 60)
plot(ice_obj)
print(Sys.time() - START)

partial(model_all,
        var,
        ice=T,
        plot=T,
        plot.engine = 'ggplot2',
        alpha=0.1,
        grid.resolution = 60
) %>% print