#---------------------------prepare data----------------------------------------
train0_gam <- polarise(MELBOURNE_CENTRE,train0)
#variable selection
#train0_gam <- select(train0_gam,
#                   c(building_area_log
#                     #,lng
#                     #,lat
#                     ,bearing
#                     ,dist_cbd
#                     ,year_built
#                     ,nrooms
#                     ,land_area_log
#                     ,nbathroom
#                     ,type
#                     ,price))

gc <- gam.control(maxit=100)
#gam_model <- gam(formula = form ,
#    data = train0_gam ,
#    #control = gc,
#    family='gaussian'
#    )
#plot(gam_model)

#train0_gam$nbathroom_nrooms <- interaction(train0_gam$nbathroom,train0_gam$nrooms)

form <- (log(price) ~ 
            type + #this is a factor
            nrooms +
            nbathroom +
            factor(nbathroom):factor(nrooms) +
            s(building_area_log,df=15) +
            s(dist_cbd,df=30) +
            s(bearing,df=28) +
            s(year_built,df=8)
            + s(land_area_log,df=8)
            + nsupermarket_2000
            #+ nschool_2000
            #+ ncafe_1000
            + ntrain_3000
            
) %>% formula

gam_oof_preds <- rep(NA,nrow(train0))
for (i in 1:KFOLD) {
    cat(paste('fold number:',i,'of',KFOLD,'\n'))
    fold <- folds[[i]]
    
    train0_gam_fold <- train0_gam[-fold,]
    val0_gam_fold <- train0_gam[fold,]
    
    gam_model <- gam(formula = form ,
                         data = train0_gam_fold ,
                         #control = gc,
                         family='gaussian'
                         )
    
    preds <- predict(gam_model,newdata=val0_gam_fold)
    rmse <- sqrt(mean((preds-log(val0_gam_fold$price) )^2))
    cat('rmse:',rmse,'\n')
    
    gam_oof_preds[fold] <- preds
}
gam_oof_error <- sqrt(mean((gam_oof_preds-log(train0_gam$price) )^2))
cat('rmse OOF predictions:',gam_oof_error,'\n')

gam_model <- gam(formula = form ,
                 data = train0_gam ,
                 #control = gc,
                 family='gaussian'
)
summary(gam_model)
cat('rmse OOF predictions:',gam_oof_error,'\n')
plot(gam_model)

#fit to ensemble data

#These predictions will be used to validate the ensembling meta model
gam_ensemble_validation <- encode_type(ensemble_validation) %>% polarise(MELBOURNE_CENTRE,.)
gam_ens_preds <- predict(gam_model,newdata <- gam_ensemble_validation)


