res = knn_model$results
res <- select(res,c(kmax,distance,RMSE,MAE))
res <- res[res$distance!=0,]

plot_ly(data=res,x=~kmax,y=~distance,z=~MAE)





res <- knn_model$results
res <- select(res,c(kmax,distance,RMSE))
res <- res[res$distance!=0,]
res <- spread(res,key=distance,value=RMSE)
names(res) <- c('kmax','rmse_manhattan','rmse_euclidean')
ggplot(data=res,aes(x=kmax)) +
    geom_line(aes(y=rmse_manhattan),color='orange',lwd=2) +
    geom_line(aes(y=rmse_euclidean),color='#0078D7',lwd=2) + 
    ylim(c(0,0.4))


