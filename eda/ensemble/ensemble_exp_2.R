#REQUIRES AN ENSEMBLE MODEL WITH FEATURES OTHERS THAN THE META-FEATURES

#ens_data <- ensemble_train_x
ens_data <- cbind(ensemble_train_x,select(train0,-type_encoded))

#pred_data <- gather(ens_data,key='model',value='prediciton')
#pred_data$model <- factor(pred_data$model)
#model_names <- levels(ens_data$model) %>% strapplyc('^(...)_') %>% as.character()
#revalue(ens_data$model,model_names)
#head(pred_data)


resid_data <- ens_data
resid_data$xgb_resid <- sqrt((resid_data$xgb_oof_preds-log(train0$price))^2)
resid_data$knn_resid <- sqrt((resid_data$knn_oof_preds-log(train0$price))^2)
resid_data$gam_resid <- sqrt((resid_data$gam_oof_preds-log(train0$price))^2)

resid_data <- select(resid_data,-c(xgb_oof_preds,knn_oof_preds,gam_oof_preds))
resid_data <- gather(resid_data,key='model',value='residual',xgb_resid,knn_resid,gam_resid)


xgb_oof_error
sqrt(mean(resid_data[resid_data$model=='xgb_resid',]$residual^2))


ggplot(resid_data,aes(x=building_area_log,y=log(residual))) + geom_point(alpha=0.5) + facet_grid(factor(model)~.) 
ggplot(resid_data,aes(x=nbathroom,y=log(residual))) + geom_jitter(alpha=0.5) + facet_grid(factor(model)~.) 
ggplot(resid_data,aes(x=ncar,y=log(residual))) + geom_jitter(alpha=0.5) + facet_grid(factor(model)~.) 

ggplot(resid_data,aes(x=building_area_log,y=residual)) + geom_point(alpha=0.5) + facet_grid(factor(model)~.) 
ggplot(resid_data,aes(x=nbathroom,y=residual)) + geom_jitter(alpha=0.5) + facet_grid(factor(model)~.) 
ggplot(resid_data,aes(x=ncar,y=residual)) + geom_jitter(alpha=0.5) + facet_grid(factor(model)~.) 



#ens_data <- cbind(resid_data,pred_data)

way_off <- which(resid_data$residual>2) #some duplicates because of gather
resid_data$ID[way_off]
way_off_id <- resid_data$ID[way_off]
way_off_ind <- which(train0$ID %in% way_off_id)

way_off <- which(resid_data$residual>0.9) #some duplicates because of gather
resid_data$ID[way_off]
way_off_id <- resid_data$ID[way_off]
way_off_ind <- which(train0$ID %in% way_off_id)
