ice_obj = ice(xgb_model,
              X = as.matrix(xgb_train0_x),
              y = xgb_train0_y,
              predictor=2,
              verbose=F,
              num_grid_pts = 60,
              frac_to_build = 0.1
)
plot(ice_obj,plot_orig_pts_preds = F,centered = T)

dtrain <- as.matrix(xgb_train0_x)
#CONSIDER trim.outliers=TRUE
#maybe adjust grid.resolution
partial(knn_model,pred.var=c('lng','lat'),plot=T,plot.engine = 'ggplot2',grid.resolution = 5,progress = progress_text(3))

partial(xgb_model,pred.var=c('lng','lat'),plot=T,plot.engine = 'ggplot2',grid.resolution = 50,progress = progress_text(3))
#---------------------
dtrain <- as.matrix(xgb_train0_x)
plot_data <- partial(xgb_model,pred.var=c('bearing','dist_cbd'),grid.resolution = 200,progress = progress_text(3))

plot_data <- cbind(destPoint(MELBOURNE_CENTRE,plot_data$bearing,plot_data$dist_cbd),plot_data$yhat)
plot_data <- as.data.frame(plot_data)
names(plot_data) <- c('lng','lat','yhat')

ggplot(plot_data,aes(x=lng,y=lat,fill=yhat)) +geom_tile()

#lng_vec=seq(144.4,145.6,0.0005)
#lat_vec =seq(-38.25,-37.05,0.0005)
plot_data_2 <- plot_data
plot_data_2$lng <- round(plot_data_2$lng,2) #2nd arg important
plot_data_2$lat <- round(plot_data_2$lat,2)
ggplot(plot_data_2,aes(x=lng,y=lat,fill=yhat)) +geom_tile()

#lng_vec=seq(144.4,145.6,0.01) #last arg important
#lat_vec =seq(-38.25,-37.05,0.01)
#l <- length(lng_vec)
#d <- data.frame(lng=rep(lng_vec,l),lat=rep(lat_vec,each=l))
#merge(d,plot_data_2,by=c('lng','lat')) #this doesnt do anything

ggplot(plot_data_2,aes(x=lng,y=lat,fill=yhat)) +geom_tile()
#----------------------------------------------





###
s <- data.frame(x=rep(1:4,4),y=rep(1:4,each=4),z=rnorm(16))
s$x2 <- jitter(s$x)
ggplot(s,aes(x=x,y=y,fill=z)) + geom_tile()
###

start <- Sys.time()
dtrain <- as.matrix(xgb_train0_x)
partial(xgb_model,pred.var=c('lng','lat'),plot=T,plot.engine = 'ggplot2',grid.resolution = 100,progress = progress_text(3))
print(Sys.time() - start)
