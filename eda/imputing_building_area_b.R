#use all data that is not test and has year_built to create a model to impute building_area
BA_impute_data <- rbind(property_data[no_pricing,],
                          property_data[train_ensbl_Index,])

BA_model <- lm(log(building_area) ~ nrooms +nbathroom + type,data=BA_impute_data)

to_impute <- is.na(property_data$building_area)
property_data[to_impute,'building_area'] <- predict(BA_model,newdata = property_data[to_impute,]) %>% exp
property_data$imputed_building_area <- to_impute*1


#sanity check
#plot(property_data$building_area,log(property_data$price),col=rgb(property_data$imputed_building_area,0,0,0.2),pch=19)
