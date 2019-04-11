#use all data that is not test and has year_built to create a knn model
year_impute_data <- rbind(property_data[no_pricing,],
                          property_data[train_ensbl_Index,]) %>% select(c(lng,lat,year_built))
#construct a knn model using only lng and lat, 

#dump anything without year_built
year_impute_data <- year_impute_data[complete.cases(year_impute_data),]

year_impute_data_x <- select(year_impute_data,-year_built)
year_impute_data_y <- year_impute_data$year_built

set.seed(54384)
year_model = train(x=year_impute_data_x,
                   y=year_impute_data_y,
                   method='knn',
                   metric='MAE',
                   tunegrid=data.frame(k=1:50),
                   trControl = trainControl(
                       method='repeatedcv',number=10,repeats=5
                   ),
                   verbose=TRUE
)
to_impute = is.na(property_data$year_built)
property_data[to_impute,'year_built'] = predict(year_model$finalModel,
                                                newdata = property_data[to_impute,c('lng','lat')])
property_data$imputed_year_built = 1*to_impute


#sanity check
#plot(property_data$year_built,log(property_data$price),col=rgb(property_data$imputed_year_built,0,0,1))
