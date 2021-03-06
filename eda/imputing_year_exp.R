library(caret)

train0_year = select(train0,c(year_built,lng,lat))

#training data
training_bool = !is.na(train0$year_built)
year_train = train0_year[training_bool,]
year_train_x = select(year_train,-year_built)
year_train_y = year_train$year_built
#testing data
year_test = train0_year[!training_bool,]
year_test_x = select(year_test,-year_built)
year_test_y = year_test$year_built

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
imputed_years = round(predict(year_model$finalModel,year_test_x),0)
train0_impyear = train0
train0_impyear[!training_bool,]$year_built = imputed_years
train0[!training_bool,]$year_built = imputed_years
train0$imputed_year_built = (!training_bool)*1

