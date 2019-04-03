library(leaflet)
###--------------Imputing--------------------------------------------------

#year built
    #geo neighbours
#42% of data is missing
mean(is.na(property_data$year_built))


#land_area
    #geo and nrooms building_area neighbours
#building_area
    #geo and nrooms land_area neighbours
#price
    #do not impute
#ncar
    #exploratory linear models suggest possibly no impact, impute based on a number of factors
