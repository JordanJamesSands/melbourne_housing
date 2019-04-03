folds = createFolds(train0$price,k=10,list=TRUE)
sapply(folds,length)
