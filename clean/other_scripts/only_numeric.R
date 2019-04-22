onlynumeric <- function(prop_data) {
    select(prop_data,c(nrooms,price,nbathroom,ncar,land_area,building_area,year_built,lat,lng))
}

d = onlynumeric(property_data)[complete.cases(onlynumeric(property_data)),]
cor(d)
