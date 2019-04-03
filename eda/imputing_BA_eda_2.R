
with(train0,
     plot(log(building_area),col=rgb(as.numeric(imputed_building_area),0,0,0.2),pch=19)
)

with(train0,
     plot(jitter(nrooms,2),log(building_area),col=rgb(as.numeric(imputed_building_area),0,0,0.2),pch=19)
)

with(train0,
     plot(jitter(nbathroom,2),log(building_area),col=rgb(as.numeric(imputed_building_area),0,0,0.2),pch=19)
)

with(train0,
     plot(jitter(ncar,2),log(building_area),col=rgb(as.numeric(imputed_building_area),0,0,0.2),pch=19)
)
with(train0,
     plot(lng,log(building_area),col=rgb(as.numeric(imputed_building_area),0,0,0.2),pch=19)
)
with(train0,
     plot(lat,log(building_area),col=rgb(as.numeric(imputed_building_area),0,0,0.2),pch=19)
)
with(train0,
     plot(jitter(as.numeric(type),2),log(building_area),col=rgb(as.numeric(imputed_building_area),0,0,0.2),pch=19)
)
with(train0,
     plot(log(land_area),log(building_area),col=rgb(as.numeric(imputed_building_area),0,0,0.2),pch=19)
)

