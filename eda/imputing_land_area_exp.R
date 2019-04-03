#simply average the land_area for intersection of nrooms, ncar, type
mod <- lm(log(land_area) ~ factor(nrooms) + factor(ncar) + type,data=train0)

train0_missing_LA = train0[is.na(train0$land_area),]
imputed_land_area = exp(predict(mod,newdata=train0_missing_LA))

train0_copy = train0
train0_copy[is.na(train0$land_area),'land_area'] = imputed_land_area
train0_copy$imputed_land_area = 1*(is.na(train0$land_area))

#train0[is.na(train0$land_area),'land_area'] = imputed_land_area
#train0$imputed_land_area = 1*(is.na(train0$land_area))
