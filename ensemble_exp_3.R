#ens_data <- ensemble_train_x
ens_data <- cbind(ensemble_train_x,train0)
resid_data <- ens_data
resid_data$xgb_resid <- sqrt((resid_data$xgb_oof_preds-log(train0$price))^2)
resid_data$knn_resid <- sqrt((resid_data$knn_oof_preds-log(train0$price))^2)
resid_data$gam_resid <- sqrt((resid_data$gam_oof_preds-log(train0$price))^2)

xgb_less_knn <- resid_data$xgb_resid - resid_data$knn_resid

plot(log(ens_data$building_area) ,xgb_less_knn) ; abline(h=0)
plot(jitter(ens_data$nrooms,2),xgb_less_knn) ; abline(h=0)
plot(log(ens_data$land_area),xgb_less_knn) ; abline(h=0)
plot(ens_data$dist_cbd,xgb_less_knn , col=rgb(0,0,0,0.2)) ; abline(h=0)
mod <- lm( xgb_less_knn ~ ens_data$dist_cbd)
abline(mod)
plot(ens_data$bearing,xgb_less_knn , col=rgb(0,0,0,0.2)) ; abline(h=0)
plot(ens_data$type,xgb_less_knn, col=rgb(0,0,0,0.2)) ; abline(h=0)
plot(ens_data$lng,xgb_less_knn, col=rgb(0,0,0,0.2)) ; abline(h=0)
plot(ens_data$lat,xgb_less_knn, col=rgb(0,0,0,0.2)) ; abline(h=0)
