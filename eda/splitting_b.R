library(caret)
set.seed(4723846)
#remove no price data
no_pricing <- is.na(property_data$price)
property_data <- property_data[!is.na(property_data$price),]

#split
train_ensbl_Index <- createDataPartition(property_data$price,times=1,p=0.8,list=F)


