mod <- lm(log(building_area) ~ nrooms +nbathroom + type,data=train0)

train0_missing_BA = train0[is.na(train0$building_area),]
imputed_building_area = exp(predict(mod,newdata=train0_missing_BA))

train0_copy = train0
train0_copy[is.na(train0$building_area),'building_area'] = imputed_building_area
train0_copy$imputed_building_area = 1*(is.na(train0$building_area))
