library(googleway)
library(geosphere)
library(dplyr)
download_local <- function(searchstring,lat,lng) {
    PRIVATE_KEY = 'AIzaSyDqxSZqABI9K6fHoFEZ4HiZrmX-zv_ljL4'
    #send request
    req = google_places(search_string = searchstring,location=c(lat,lng),key=PRIVATE_KEY)
    
    #parse data from returned object
    res_data = req$results
    if(length(res_data)<1) {
        return(NULL)
    }
    res_data = cbind(res_data$name,res_data$geometry$location)
    names(res_data) = c('name','lat','lng')
    res_data$name = as.character(res_data$name)

    #compute distances
    res_data$distance = apply(select(res_data,c(lng,lat)),1,function(x){
        distm(x,c(lng,lat))
    })
    
    #sort by distance
    res_data = res_data[order(res_data$dist),]
    
    return(res_data)
}