#in eda_linear_models.R it was found that nbedrooms and nrooms had significant correlation, lets explore this further
with(d,plot(jitter(nrooms),jitter(nbedroom),pch=19,col=rgb(0,0,0,0.1)))

#lets study the correlation after removing nbedroom and nbathroom outliers
d_cropped <- subset(d,nbedroom<=6 & nbathroom<=4)
bool = !is.na(d_cropped$nbedroom) & !is.na(d_cropped$nrooms)
cor(d_cropped$nbedroom[bool],d_cropped$nrooms[bool])
#still highly correlated at 0.9677784

#now a replot
with(d_cropped,plot(jitter(nrooms),jitter(nbedroom),pch=19,col=rgb(0,0,0,0.1)))
#notice that many properties have nbedroom higher than nrooms
mean(d$nbedroom>d$nrooms,na.rm=T)
#properties really shouldnt have nbedroom == nrooms, cos of the bathroom
mean(d$nbedroom>=d$nrooms,na.rm=T)
