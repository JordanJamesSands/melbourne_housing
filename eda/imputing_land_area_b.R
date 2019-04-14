#use all data that is not test and has year_built to create a model to impute land_area
land_impute_data <- rbind(property_data[no_pricing,],
                          property_data[train_ensbl_Index,])

#simply average the land_area for intersection of nrooms, ncar, type
land_model <- lm(log(land_area) ~ factor(nrooms) + factor(ncar) + type,data=land_impute_data)

to_impute = is.na(property_data$land_area)
property_data[to_impute,'land_area'] = predict(land_model,newdata = property_data[to_impute,]) %>% exp
property_data$imputed_land_area = to_impute*1


#sanity check
#plot(property_data$land_area,log(property_data$price),col=rgb(property_data$imputed_land_area,0,0,0.2),pch=19)
