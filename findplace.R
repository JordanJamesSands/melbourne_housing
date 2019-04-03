library(googleway)
library(geosphere)
findplace <- function(searchstring,lat,lng,distances) {
    #print(paste('lng=',lng))
    PRIVATE_KEY = 'AIzaSyDqxSZqABI9K6fHoFEZ4HiZrmX-zv_ljL4'
    loc = c(lat,lng)
    res_data = google_places_all(search_string=searchstring,location=loc,radius=1,key=PRIVATE_KEY)
    
    #filter according to distance
    res_data$distance = apply(res_geo,1,function(x){
        distm(c(x[2],x[1]),c(lng,lat))
    })
    #sort, probably not neccesary
    res_data = res_data[order(res_data$dist),]
    #print(res_data)
    
    return_data = list()
    i=1
    for(dist in distances){
        return_data[[i]] = sum(res_data$distance<dist)
        i = i+1
    }
    names(return_data) = distances
    return(return_data)
    
}

extract_places_data <- function(req) {
    return_data = req$results
    return_data = cbind(return_data$name,return_data$geometry$location)
    names(return_data) = c('name','lat','lng')
    return_data$name = as.character(return_data$name)
    return_data
}

google_places_all <- function(...) {
    req = google_places(...)
    return_data = extract_places_data(req)
    
    #i have to sleep between requets, maybe dont bother with the next page token,
    #besides, who wants more than 20 parks, schools, supermarkets nearby, if i need the next page
    #then maybe i should be using smaller neighbourhood distances
    
    #while (!is.null(req$next_page_token)) {
    #    #ADD SOMETHING TO THE WHILE GUARD SO THAT IS THE DISTANCE IS ALREADY
    #    #FAR ENOUGH WE DONT PULL MORE DATA?
    #    req = google_places(...,page_token=req$next_page_token)
    #    return_data = rbind(return_data,extract_places_data(req))
    #    Sys.sleep(2)
    #}
    return(return_data)
}



count_places <- function(searchstring,lat,lng,distance) {
    place_data = findplace(searchstring,lat,lng,distance)
    if(dim(place_data)>=20) {
        print('at least 20 places found!')
    }
    
    
    
}
