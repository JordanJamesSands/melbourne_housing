#---------------------------prepare data----------------------------------------
train0_gam <- encode_type(train0)
train0_gam <- polarise(MELBOURNE_CENTRE,train0_gam)
#variable selection
train0_gam <- select(train0_gam,
                   c(building_area
                     #,lng
                     #,lat
                     ,bearing
                     ,dist_cbd
                     ,year_built
                     ,type_encoded
                     ,nrooms
                     ,land_area
                     ,type
                     ,price))

gc = gam.control(maxit=100)
#gam_model <- gam(formula = form ,
#    data = train0_gam ,
#    #control = gc,
#    family='gaussian'
#    )
#plot(gam_model)

form = (log(price) ~ 
            s(building_area,df=10) +
            s(dist_cbd,df=10) +
            s(bearing,df=10) +
            s(year_built,df=2) +
            type +
            #s(nrooms,df=2) +
            s(factor(nrooms)*factor(nbathroom),df=2) +
            s(land_area,df=2)
) %>% formula

oof_preds = rep(NA,nrow(train0))
for (i in 1:KFOLD) {
    cat(paste('fold number:',i,'of',KFOLD,'\n'))
    fold = folds[[i]]
    
    train0_gam_fold = train0_gam[-fold,]
    val0_gam_fold = train0_gam[fold,]
    
    gam_model <- gam(formula = form ,
                         data = train0_gam_fold ,
                         #control = gc,
                         family='gaussian'
                         )
    
    preds = predict(gam_model,newdata=val0_gam_fold)
    rmse = sqrt(mean((preds-log(val0_gam_fold$price) )^2))
    cat('rmse:',rmse,'\n')
    
    oof_preds[fold] = preds
}
gam_oof_error <- sqrt(mean((oof_preds-train0_y )^2))
cat('rmse OOF predictions:',gam_oof_error,'\n')

gam_model <- gam(formula = form ,
                 data = train0_gam ,
                 #control = gc,
                 family='gaussian'
)
