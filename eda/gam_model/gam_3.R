#---------------------------prepare data----------------------------------------
train0_gam <- polarise(MELBOURNE_CENTRE,train0)

#the formula for the generalised additive model, s(X,df=i) fits a spline to 
#the relationship between feature X  and the target with i degrees of freedom
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

#initialise gam parameters
gc <- gam.control(maxit=100)
#initialise out of fold prediction vector
gam_oof_preds <- rep(NA,nrow(train0))


for (i in 1:KFOLD) {
    fold <- folds[[i]]
    
    #prepare fold specific data
    train0_gam_fold <- train0_gam[-fold,]
    val0_gam_fold <- train0_gam[fold,]
    
    #fit a gam model
    gam_model <- gam(formula = form ,
                     data = train0_gam_fold ,
                     #control = gc,
                     family='gaussian'
    )
    
    #update prediction vector
    preds <- predict(gam_model,newdata=val0_gam_fold)
    gam_oof_preds[fold] <- preds
}

#compute out of fold error
gam_oof_error <- sqrt(mean((gam_oof_preds-log(train0_gam$price) )^2))

#retrain with all train0 for construction of the ensembling meta model validation set
gam_model <- gam(formula = form ,
                 data = train0_gam ,
                 #control = gc,
                 family='gaussian'
)

#exp
summary(gam_model)
cat('rmse OOF predictions:',gam_oof_error,'\n')
plot(gam_model)
