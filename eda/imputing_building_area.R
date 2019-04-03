mod <- lm(log(building_area) ~ nrooms +nbathroom + type,data=property_data)

data_missing_BA = property_data[is.na(property_data$building_area),]
imputed_building_area = exp(predict(mod,newdata=data_missing_BA))

property_data$imputed_building_area = 1*(is.na(property_data$building_area))
property_data[is.na(property_data$building_area),'building_area'] = imputed_building_area

