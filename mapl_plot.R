#----------------------lnglat
leaflet(property_data) %>% addTiles %>% addCircles(lng=~lng,lat=~lat,
                                                   opacity = 1,
                                                   fillOpacity = 1,
                                                   radius=1000)
