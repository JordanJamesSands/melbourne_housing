#use all data that is not test and has year_built to create a model to impute ncar
ncar_impute_data <- rbind(property_data[no_pricing,],
                           property_data[train_ensbl_Index,])

ncar_model <- lm(ncar ~ nrooms + nbathroom, data=ncar_impute_data)

#impute
to_impute = is.na(property_data$ncar)
property_data[to_impute,'ncar'] = predict(ncar_model,
                                                newdata = property_data[to_impute,]) %>% round(0)
property_data$imputed_ncar = to_impute*1

#sanity check
#plot(jitter(property_data$ncar,2),log(property_data$price),col=rgb(property_data$imputed_ncar,0,0,1))
