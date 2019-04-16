library(dplyr)
library(plyr)

select_cols <- function(df,numeric_only=FALSE,extra_feature_names=NULL,include_impute_flags=F) {
    columns_to_use = c('nrooms','type','type_encoded','method','nbathroom',
                       'ncar','land_area','building_area','year_built','lat','lng',
                       'region','council_area','propcount','price')
    
    cat_cols = c('type', 'method' ,'council_area', 'region') 
    
    if(include_impute_flags) {
        columns_to_use = c(columns_to_use,extra_feature_names,'imputed_year_built','imputed_ncar',
          'imputed_land_area','imputed_building_area')
    } else {
        columns_to_use = c(columns_to_use,extra_feature_names)
    }
    df = select(df,columns_to_use)
    if (numeric_only) {
        return (select(df,-cat_cols))
    }
    else {
        return (df)
    }
}

encode_type <- function(df) {
    df$type_encoded = revalue(df$type,replace=c('Unit'='1','Townhouse'='2','House'='3')) %>% as.numeric
    return (df)
}
encode_method <- function(df) {
    df$method_encoded = revalue(df$method,replace=c('SP'='1','SA'='2','S'='3')) %>% as.character %>% as.numeric
    return (df)
}

download_google_api_data <- function(df,searchstring) {
    location_data = select(df,c(ID,lat,lng))
    api_data_list = list()
    START = Sys.time()
    for(i in 1:nrow(df)) {
        runtime = round(as.numeric(Sys.time() - START)/60,2)
        perc_complete = round(100*(i-1)/nrow(df),2)
        cat(paste('Computing for object',i,'of',nrow(df),'\n'))
        cat(paste0('Progress: ',perc_complete,'%\n'))
        cat(paste('Total runtime =',runtime,'minutes','\n'))
        
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
