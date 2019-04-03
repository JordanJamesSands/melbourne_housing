#change building_area>1000 to land_area>10000 to analyse land_area
#typo, should be called bad_ba
#good_ba = subset(property_data,building_area>1000)
#good_ba = subset(property_data,land_area>10000)
good_ba = subset(property_data,ncar>5)



with(property_data,
     plot(jitter(nrooms),price,pch=19,col=rgb(0,0,0,0.2))
     )
points(good_ba$nrooms,good_ba$price,pch=19,col='red')

with(property_data,
     plot(jitter(nbathroom),price,pch=19,col=rgb(0,0,0,0.2))
)
points(good_ba$nbathroom,good_ba$price,pch=19,col='red')

with(property_data,
     plot(lat,price,pch=19,col=rgb(0,0,0,0.2))
)
points(good_ba$lat,good_ba$price,pch=19,col='red')

with(property_data,
     plot(lng,price,pch=19,col=rgb(0,0,0,0.2))
)
points(good_ba$lng,good_ba$price,pch=19,col='red')

with(property_data,
     plot(precomputeddist,price,pch=19,col=rgb(0,0,0,0.2))
)
points(good_ba$precomputeddist,good_ba$price,pch=19,col='red')
