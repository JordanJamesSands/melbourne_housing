train_data = property_data[train_ensbl_Index,]
test_data = property_data[-train_ensbl_Index,]

### now split train

set.seed(43535929)
splitIndex = createDataPartition(train_data$price,times=1,p=0.75,list=F)
#splitIndex = splitIndex_old_2

train0 = train_data[splitIndex,]
train1 = train_data[-splitIndex,]

folds = createFolds(train0$price,k=10,list=TRUE)
sapply(folds,length)