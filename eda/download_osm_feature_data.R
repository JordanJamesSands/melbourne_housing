source('eda/download_osm_at_point.R')

download_osm_feature_data <- function(df,key,value,radius,dist_threshold,sleepdelay=1,index_range=NULL,plot=F) {
    if(!is.null(index_range)) {
        get_ind = seq(index_range[1],index_range[2])
        df = df[get_ind,]
    }
    
    
    data_list = list()
    START = Sys.time()
    
    for(i in 1:nrow(df)) {
        #--------------- print progress -----------------------------------
        runtime = as.numeric(difftime(Sys.time(),START,units='secs'))/60
        estimated_runtime = runtime*nrow(df)/i
        perc_complete = round(100*(i-1)/nrow(df),2)
        cat(paste('Computing for object',i,'of',nrow(df),'\n'))
        cat(paste0('Progress: ',perc_complete,'%\n'))
        cat(paste('Total runtime =',round(runtime,2),'minutes','estimated:',
                  round(estimated_runtime,2),'minutes','\n'))
        #----------------------------------------------------------
        
        loc_row = df[i,]
        lat = loc_row$lat
        lng = loc_row$lng
        ID = loc_row$ID
        
        local_data = download_osm_at_point(lng,lat,key,value,radius,dist_threshold,plot)
        data_list[[ID]] = local_data
        
        #randomise sleep
        #delay = runif(1,0,sleepdelay)*2
        delay = sleepdelay
        cat(paste0('delay=',round(delay,2),' seconds','\n'))
        Sys.sleep(delay)
    }
    
    cat('Saving to disk...\n')
    index_range_string = paste(index_range,collapse='-')
    filename=paste0('gen_data/osm_data_',key,'=',value,'_',index_range_string,'.Robject')
    save(data_list,file = filename)
    return(data_list)
}
