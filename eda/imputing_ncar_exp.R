mod <- lm(ncar ~ nrooms + nbathroom, data=train0)

train0_missing_ncar = train0[is.na(train0$ncar),]
imputed_ncar = round(predict(mod,newdata=train0_missing_ncar),0)

train0_copy = train0
train0_copy[is.na(train0$ncar),'ncar'] = imputed_ncar
train0_copy$imputed_ncar = 1*(is.na(train0$ncar))
