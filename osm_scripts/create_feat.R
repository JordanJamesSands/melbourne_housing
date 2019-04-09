#maybe get a bigger distance on train and supermarket? (also kinder?)

n_neighbours <- function(osm_data_list,radius,featname) {
    IDs = sapply(osm_data_list,function(x){x$ID})
    nneighs = sapply(osm_data_list,function(x){sum(x$dists<radius)})
    
    df = data.frame(ID=IDs,nneighs)
    names(df)[2] = featname
    return(df)
}

min_dist <- function(osm_data_list,num,featname,maxdist) {
    IDs = sapply(osm_data_list,function(x){x$ID})
    meandist = sapply(osm_data_list,function(x){
        sorted_dists = sort(x$dists)
        ret = mean(sorted_dists[1:num],na.rm = T)
        
        if(is.na(ret)) {
            return(maxdist)
            } 
        else {
            return(ret)
        }
    }
    )
    df = data.frame(ID=IDs,meandist)
    names(df)[2] = featname
    return(df)
}
