#----compute distance from city and bearings------------------------------------
polarise <- function(lnglat_centre,df) {
    locs = select(df,c(lng,lat))
    df$dist_cbd = apply(locs,1,function(loc){distm(loc,lnglat_centre)})
    df$bearing =apply(select(df,c(lng,lat)),1,function(x){
        bearing(lnglat_centre,x)
    })
    return(df)
}