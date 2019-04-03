boolA <- property_data$nrooms<=6 & property_data$nbathroom<=4 & property_data$nbathroom>0

sum(is.na(property_data$nbathroom))
dim(property_data)
cat('\n')
property_data_subset <- subset(property_data,nrooms<=6 & nbathroom<=4 & nbathroom>0)
sum(is.na(property_data_subset$nbathroom))
dim(property_data_subset)
cat('\n')
property_data_conv <- property_data[boolA,]
sum(is.na(property_data_conv$nbathroom))
dim(property_data_conv)
