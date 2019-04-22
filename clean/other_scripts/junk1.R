library(caret)
y = c(1,3,2,5,4,5,6,7,6,5)
length(y)
s = createDataPartition(y,times=5,p=0.5)

for (i in 1:10){
    print(mean(sapply(s,function(x){1 %in% x})))
}