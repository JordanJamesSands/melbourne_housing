#simply average the land_area for intersection of nrooms, ncar, type

mod <- lm(log(land_area) ~ factor(nrooms) + factor(ncar) + type,data=property_data)

data_missing_LA = property_data[is.na(property_data$land_area),]
imputed_land_area = exp(predict(mod,newdata=data_missing_LA))

property_data$imputed_land_area = 1*(is.na(property_data$land_area))
property_data[is.na(property_data$land_area),'land_area'] = imputed_land_area


