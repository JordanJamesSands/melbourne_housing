library(caret)

df_year = select(property_data[splitIndex,],c(year_built,lng,lat))

#training data
training_bool = !is.na(df_year$year_built)
year_train = df_year[training_bool,]
year_train_x = select(year_train,-year_built)
year_train_y = year_train$year_built


set.seed(54384)
year_model = train(x=year_train_x,
                   y=year_train_y,
                   method='knn',
                   metric='MAE',
                   tunegrid=data.frame(k=1:50),
                   trControl = trainControl(
                       method='repeatedcv',number=10,repeats=5
                   ),
                   verbose=TRUE
)
to_impute = property_data[]
property_data[to_impute,'year_built'] = predict(year_model$finalModel,
                                                newdata = property_data[to_impute,c('lng','lat')]) %>% 
    round(0)

imputed_years = round(predict(year_model$finalModel,year_test_x),0)
property_data[!training_bool,]$year_built = imputed_years
property_data[!training_bool,]$year_built = imputed_years
property_data$imputed_year_built = (!training_bool)*1


#train0_impyear = train0
#train0_impyear[!training_bool,]$year_built = imputed_years
#train0[!training_bool,]$year_built = imputed_years
#train0$imputed_year_built = (!training_bool)*1

