
#for testing the dropping of imputed values
sapply(folds,function(x){length(x)})

rm(imputed)

imputed_ba = train0$imputed_building_area==1
imputed_la = train0$imputed_land_area==1
imputed_yb = train0$imputed_year_built==1
imputed_ncar = train0$imputed_ncar==1

imputed = c()
#imputed = which(imputed_ba)
#imputed = which(imputed_ba | imputed_la | imputed_yb | imputed_ncar)


#record IDs
folds_ids = list()
for(i in 1:length(folds)) {
    folds_ids[[i]] = train0[folds[[i]],'ID']
}
#reduce train set
train0 = train0[-imputed,]

#regenerate folds list
for(i in 1:length(folds_ids)) {
    folds[[i]] = which(train0$ID %in% folds_ids[[i]])
}

sapply(folds,function(x){length(x)})


