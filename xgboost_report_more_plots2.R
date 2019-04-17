#partial(xgb_model,c('building_area','dist_cbd'),grid.resolution = 20,plot = T,plot.engine = 'ggplot2')



#hack, this is neccesary because the pdp package doesn't behave well with xgboost
#dtrain <- as.matrix(xgb_train0_x)
#pred_vals <- select(xgb_train0_x,building_area,dist_cbd)
#pred_vals <- pred_vals[pred_vals$building_area<200,]

#toplot <- partial(xgb_model,c('building_area','dist_cbd'),grid.resolution = 5)

##################################################################################
pred_vals <- matrix(rep(1:20,each=160),nrow=20)






#hack, this is neccesary because the pdp package doesn't behave well with xgboost
pred_vals <- data.frame(building_area=rep(10*(1:20),20) , dist_cbd = rep(750*(1:20),each=20))
dtrain <- as.matrix(xgb_train0_x)
toplot <- partial(xgb_model,c('building_area','dist_cbd'),pred.grid = pred_vals)
ggplot(toplot,aes(x=building_area,y=dist_cbd,fill=yhat)) + geom_tile()

ecdf(xgb_train0_x$building_area)(200)
ecdf(xgb_train0_x$dist_cbd)(15000)
