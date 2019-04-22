for_tune_log <- select(train0_knn,-price)
tune_log = matrix(ncol=ncol(for_tune_log)+2,nrow=0) %>% data.frame
names(tune_log) <- names(for_tune_log)
names(tune_log)[ncol(tune_log)-1] <- 'oof_score'
names(tune_log)[ncol(tune_log)] <- 'cv_score'

# put this in a script
#nam <- names(tune_log)
#tune_log <- rbind(tune_log,c((names(select(train0_knn,-price)) %in%  names(train0_x))*1,oof_error))
#names(tune_log) <- nam
#tune_log


#--------------------
#nice mix in knn is below 
#although i didnt check if the optimal k was on the boundary while searching
#also didnt scale
#c(building_area,lng,lat,type_encoded,nrooms,land_area)

#with a silly dilation list, (still didnt check for boundary k values)
#good was
#c(building_area,lng,lat,type_encoded,nrooms) 0.1817020