ens_data <- ensemble_train_x
ens_data$target <- log(train0$price)
ens_data %>% head
ens_data$xgb_resid <- sqrt((ens_data$xgb_oof_preds-ens_data$target)^2)
ens_data$knn_resid <- sqrt((ens_data$knn_oof_preds-ens_data$target)^2)
ens_data$gam_resid <- sqrt((ens_data$gam_oof_preds-ens_data$target)^2)
ens_data$lat <- train0$lat

ggplot(ens_data,aes(x=lat,y=))


#check
sqrt(mean(ens_data$xgb_resid^2))
xgb_oof_error
#######

ens_data <- gather(ens_data,key='model',value='prediction',-c(target,xgb_resid,gam_resid,knn_resid))
ens_data <- gather(ens_data,key='model',value='error',-c(target,prediction)) 

#ens_data$error <- as.numeric(ens_data$error)

head(ens_data)
