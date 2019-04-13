parse_osm_data <- function(df) {
    osm_features = c()
    for(file in list.files('osm_data')) {
        feat_type = strapplyc(file,'value=(.*?)_',simplify = T)
        max_radius = strapplyc(file,'radius=(.*?)_',simplify=T) %>% as.numeric
        
        cat(paste('reading',file,'\n'))
        address = paste0('osm_data/',file)
        osm_data = load(address,verbose=T)
        
        featname = paste0('n',feat_type,'_',max_radius)
        osm_data_neighbours = n_neighbours(osm_data=data_list,radius=max_radius,featname)
        df = merge(df,osm_data_neighbours)
        osm_features = c(osm_features,featname)
        
        
        featname = paste0(feat_type,'_','min_dist')
        osm_data_mindist = min_dist(osm_data=data_list,num=1,featname,maxdist=9999)
        df = merge(df,osm_data_mindist)
        osm_features = c(osm_features,featname)
    }
    return(df)
}
train0 <- parse_osm_data(train0)

