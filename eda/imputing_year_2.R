library(caret)

df_year = select(train_data,c(year_built,lng,lat))

#training data
training_bool = !is.na(df_year$year_built)
year_train = df_year[training_bool,]
year_train_x = select(year_train,-year_built)
year_train_y = year_train$year_built
nrow(year_train_x)

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
#now use the model to fill NAs in all data, not just train_data

#impute on train_data
to_impute = is.na(train_data$year_built)
train_data[to_impute,'year_built'] = predict(year_model$finalModel,newdata = train_data[to_impute,c('lng','lat')]) %>% round(0)
train_data$imputed_year_built = to_impute*1
#inpute on test_data
to_impute = is.na(test_data$year_built)
test_data[to_impute,'year_built'] = predict(year_model$finalModel,newdata = test_data[to_impute,c('lng','lat')]) %>% round(0)
test_data$imputed_year_built = to_impute*1

#---old
#imputed_years = predict(year_model$finalModel,year_test_x) %>% round(0)
#property_data[!training_bool,]$year_built = imputed_years
#property_data[!training_bool,]$year_built = imputed_years
#property_data$imputed_year_built = (!training_bool)*1


#train0_impyear = train0
#train0_impyear[!training_bool,]$year_built = imputed_years
#train0[!training_bool,]$year_built = imputed_years
#train0$imputed_year_built = (!training_bool)*1

