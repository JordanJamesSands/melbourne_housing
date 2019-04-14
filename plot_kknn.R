#plot_kknn
res <- knn_model$results
res <- select(res,c(kmax,distance,RMSE,MAE))
res <- res[res$distance!=0,]
res$distance_measure <- factor(ifelse(res$distance==1,'manhattan','euclidean'))

ggplot(data=res,aes(x=kmax,color=distance_measure)) +
    geom_line(aes(y=RMSE),lwd=2)

ggplot(data=res,aes(x=kmax,color=distance_measure)) +
    geom_line(aes(y=MAE),lwd=2)
