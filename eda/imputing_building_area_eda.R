with(property_data[!is.na(property_data$land_area) & !is.na(property_data$building_area),],cor(log(land_area),log(building_area)))
plot(log(train0$building_area),log(train0$price))
cor(train0[!is.na(train0$building_area),'building_area'],log(train0[!is.na(train0$building_area),]$price))

with(train0,
     plot(log(building_area),col=rgb(0,0,0,0.2),pch=19)
)

with(train0,
     plot(jitter(nrooms,2),log(building_area),col=rgb(0,0,0,0.2),pch=19)
)

with(train0,
     plot(jitter(nbathroom,2),log(building_area),col=rgb(0,0,0,0.2),pch=19)
)

with(train0,
     plot(jitter(ncar,2),log(building_area),col=rgb(0,0,0,0.2),pch=19)
)
with(train0,
     plot(lng,log(building_area),col=rgb(0,0,0,0.2),pch=19)
)
with(train0,
     plot(lat,log(building_area),col=rgb(0,0,0,0.2),pch=19)
)
with(train0,
     plot(jitter(as.numeric(type),2),log(building_area),col=rgb(0,0,0,0.2),pch=19)
)
with(train0,
     plot(log(land_area),log(building_area),col=rgb(0,0,0,0.2),pch=19)
)
