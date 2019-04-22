#---------------------------prepare data----------------------------------------
train0_gam <- polarise(MELBOURNE_CENTRE,train0)

gc <- gam.control(maxit=100)

form <- formula(
    log(price) ~ 
    type + #this is a factor
    method + #this is a factor
    factor(nbathroom)+factor(nrooms) +
    s(building_area_log,df=20) +
    s(dist_cbd,df=10) +
    s(bearing,df=28) +
    s(year_built,df=15) +
    s(land_area_log,df=10)
    + nsupermarket_2000 +
    ntrain_3000
)

#---------------------------Generate out of fold predictions--------------------

#initialise
gam_oof_preds <- rep(NA,nrow(train0))

for (i in 1:KFOLD) {
    fold <- folds[[i]]
    
    train0_gam_fold <- train0_gam[-fold,]
    val0_gam_fold <- train0_gam[fold,]
    
    gam_model <- gam(formula = form ,
                     data = train0_gam_fold ,
                     control = gc,
                     family='gaussian'
    )
    
    #add out of fold predictions for this fold
    preds <- predict(gam_model,newdata=val0_gam_fold)
    gam_oof_preds[fold] <- preds
}

#compute error
gam_oof_error <- sqrt(mean((gam_oof_preds-log(train0_gam$price) )^2))
gam_oof_error
#----------retrain the full model to generate features fo rthe meta model-------

gam_model <- gam(formula = form ,
                 data = train0_gam ,
                 control = gc,
                 family='gaussian'
)



#--------------Generate metafeatures for the ensembling meta-model--------------

#These predictions will be used to validate the ensembling meta model
gam_ensemble_validation <- encode_type(ensemble_validation) %>% 
    polarise(MELBOURNE_CENTRE,.)
gam_ens_preds <- predict(gam_model,newdata <- gam_ensemble_validation)

################################################################################
summary(gam_model)
plot(gam_model)
#gam_oof_error_saved
gam_oof_error
#gam_oof_error_saved <- gam_oof_error
