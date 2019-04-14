#------------------------read suburb data---------------------------------------

#read in suburb boundaries
locs <-  readOGR('other_data/VIC_LOCALITY_POLYGON_shp.shp',
                 GDAL1_integer64_policy = TRUE,stringsAsFactors = F,verbose=F)
#locs$VIC_LOCA_2 has suburb names, parse them to be like analysis data
locs$VIC_LOCA_2 <- capitalize(tolower(locs$VIC_LOCA_2))


#--------------------aggregate data used in analysis----------------------------
suburb_data <- group_by(property_data,suburb) %>% summarise(
    median_price = median(price,na.rm=T),
    q25 = quantile(price,0.25,na.rm=T),
    q75 = quantile(price,0.75,na.rm=T),
    mean_lng = mean(lng,na.rm=T),
    mean_lat = mean(lat,na.rm=T),
    count0 = n(),
    count = sum(!is.na(price))
    )

#---------------------------combine suburb and analysis data--------------------
#find suburbs in both datasets
locs_subset <- locs[which(locs$VIC_LOCA_2 %in% levels(suburb_data$suburb)),]

#merge data from suburb_data to locs_subset
merged <- merge(locs_subset,suburb_data,by.x='VIC_LOCA_2',by.y='suburb')

#----------------------------setup interactive text-----------------------------
prettify <- function(number) {
    format(round(number,0),big.mar=',',scientific = FALSE)
}
merged$string <- paste0(
    merged$VIC_LOCA_2,
    '<br>median price: $',prettify(merged$median_price),
    '<br>25th%: $',prettify(merged$q25),
    '<br>75th%: $',prettify(merged$q75),
    '<br>count: ',merged$count
    )

#----------------------------setup colours--------------------------------------
merged$median_perc <- percent_rank(merged$median_price)
pal <- colorNumeric('Blues',domain=range(merged$median_perc,na.rm=T))

#--------------------------------plot-------------------------------------------
lngview <- mean(merged$mean_lng,na.rm=T)
latview <- mean(merged$mean_lat,na.rm=T)
leaflet(merged) %>% addTiles() %>% 
    setView(lat=latview,lng =lngview , zoom=8) %>% 
    addPolygons(fillColor = ~pal(median_perc),
                fillOpacity = 1,
                weight=1,
                label=~lapply(string,HTML)
                )


