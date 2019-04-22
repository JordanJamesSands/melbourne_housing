to_lnglat <- function(df,ref_point) {
    location_data <- select(df,c(bearing,dist_cbd))
    apply(location_data,1,function(x){
        bearing <- x[1]
        dist_cbd <- x[2]
        
    })
}
