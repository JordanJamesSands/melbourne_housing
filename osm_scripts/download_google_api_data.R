DF = train0[sample(2),]
#testDF = data.frame(ID=c('1','2','3'),lat=c(100,-37.8079,-37.7996),lng=c(0,144.9934,144.9984),stringsAsFactors = F)

library(googleway)
library(geosphere)
library(dplyr)
download_local <- function(searchstring,lat,lng) {
    PRIVATE_KEY = 'AIzaSyDqxSZqABI9K6fHoFEZ4HiZrmX-zv_ljL4'
    #send request
    req = google_places(search_string = searchstring,
                        location=c(lat,lng),
                        key=PRIVATE_KEY)
    
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


download_google_api_data <- function(df,searchstring) {
    
    location_data = select(df,c(ID,lat,lng))
    api_data_list = list()
    START = Sys.time()
    
    for(i in 1:nrow(df)) {
        #runtime = round(as.numeric(Sys.time() - START)/60,2)
        runtime = as.numeric(Sys.time() - START)/60
        estimated_runtime = runtime*nrow(df)/i
        perc_complete = round(100*(i-1)/nrow(df),2)
        cat(paste('Computing for object',i,'of',nrow(df),'\n'))
        cat(paste0('Progress: ',perc_complete,'%\n'))
        cat(paste('Total runtime =',round(runtime,2),'minutes','estimated:',
                  round(estimated_runtime,2),'minutes','\n'))
        
        loc_row = location_data[i,]
        lat = loc_row$lat
        lng = loc_row$lng
        ID = loc_row$ID
        
        local_data = download_local(searchstring,lat,lng)
        api_data_list[[ID]] = local_data
    }
    
    cat('Saving to disk...')
    filename=paste0('gen_data/google_api_data_',searchstring,'.Robject')
    save(api_data_list,file = filename)
    return(api_data_list)
}