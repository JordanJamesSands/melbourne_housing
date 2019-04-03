library(plotly)
plot_ly(data=d,x=~nbedroom,y=~nbathroom,z= ~nrooms)
plot_ly(x=jitter(d$nbedroom,2),y=jitter(d$nbathroom,2),z=jitter( d$nrooms,2))