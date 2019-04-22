interplot <- train0 %>% group_by(nrooms,nbathroom) %>% summarise(meanlogprice = mean(log(price)))
persp(interplot$nrooms,interplot$nbathroom,interplot$price)
ggplot(interplot,aes(x=nrooms,y=nbathroom,fill=meanlogprice)) + geom_tile()
plot_ly(interplot,x=~nrooms,y=~nbathroom,z=~meanlogprice) 
plot_ly(interplot,z=~meanlogprice) %>% add_surface()

plot_mat <- matrix(NA,nrow=6,ncol=4)
for(i in 1:6) {
    for(j in 1:4) {
        z<- interplot[interplot$nrooms==i & interplot$nbathroom==j,]$meanlogprice
        if(length(z)>0) {
            plot_mat[i,j] =z
        }
         
    }
}
plot_ly(z=plot_mat) %>% add_surface()


ggplot(train0,aes(x=nrooms,y=log(price))) + facet_grid(nbathroom~.) + geom_jitter()
