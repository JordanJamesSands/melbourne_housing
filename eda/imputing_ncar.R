
mod <- lm(ncar ~ nrooms + nbathroom, data=property_data)

data_missing_ncar = property_data[is.na(property_data$ncar),]
imputed_ncar = round(predict(mod,newdata=data_missing_ncar),0)

#property_data_out = property_data
property_data$imputed_ncar = 1*(is.na(property_data$ncar))
property_data[is.na(property_data$ncar),'ncar'] = imputed_ncar

