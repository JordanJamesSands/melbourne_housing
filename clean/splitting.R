#set seed for reproducibility
set.seed(8236)

#remove data with missing price
no_pricing <- is.na(property_data$price)
property_data <- property_data[!is.na(property_data$price),]

#split data into train/ensemble-validation and test
train_ensbl_Index <- createDataPartition(property_data$price,times=1,p=0.8,list=F)
train_data <- property_data[train_ensbl_Index,]
test_data <- property_data[-train_ensbl_Index,]

### now split train_data into train0 and train1
splitIndex <- createDataPartition(train_data$price,times=1,p=0.75,list=F)
train0 <- train_data[splitIndex,]
ensemble_validation <- train_data[-splitIndex,]

#Split train0 into 5 folds
KFOLD <- 5
folds <- createFolds(train0$price,k=KFOLD,list=TRUE)

#a data point suggesting a small house sold for 9 million dollars is remapped 
#to 900,000 dollars
to_drop_id <- '19584'
to_drop_index <- (train0$ID %in% to_drop_id) %>% which
train0[to_drop_index,'price'] <- 900000