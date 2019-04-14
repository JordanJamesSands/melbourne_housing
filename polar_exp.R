MELBOURNE_CENTRE = c(144.9631,-37.8136)
bearing(MELBOURNE_CENTRE,c(145,-38))

bearing =apply(select(property_data,c(lng,lat)),1,function(x){
    bearing(MELBOURNE_CENTRE,x)
    })
