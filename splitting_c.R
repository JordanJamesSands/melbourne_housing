#set seed for reproducibility
set.seed(8236)

#remove data with missing price
no_pricing <- is.na(property_data$price)
property_data <- property_data[!is.na(property_data$price),]

#split data into train/ensemble-validation and test
train_ensbl_Index <- createDataPartition(property_data$price,times=1,p=0.8,list=F)
train_data = property_data[train_ensbl_Index,]
test = property_data[-train_ensbl_Index,]

### now split train_data into train0 and train1
splitIndex = createDataPartition(train_data$price,times=1,p=0.75,list=F)
train0 = train_data[splitIndex,]
ensemble_validation = train_data[-splitIndex,]

#Split train0 into 5 folds
KFOLD <- 5
folds = createFolds(train0$price,k=KFOLD,list=TRUE)