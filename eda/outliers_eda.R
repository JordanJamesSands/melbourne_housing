library(dplyr)
x = select(property_data,c(nrooms,nbathroom))[10:20,]
boolB <- x$nrooms<=6 & ( (x$nbathroom<=4 & x$nbathroom>0) | is.na(x$nbathroom))
dim(subset(x,nrooms<=6 & nbathroom<=4 & nbathroom>0))
dim(x[boolB,])
