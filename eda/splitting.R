library(caret)
set.seed(4723846)
#remove no price data
no_pricing = property_data[is.na(property_data$price),]

property_data = property_data[!is.na(property_data$price),]

#split
splitIndex = createDataPartition(property_data$price,times=1,p=0.8,list=F)

train_data = property_data[splitIndex,]
test_data = property_data[-splitIndex,]

### now split train

splitIndex = createDataPartition(train_data$price,times=1,p=0.75,list=F)

train0 = train_data[splitIndex,]
train1 = train_data[-splitIndex,]

