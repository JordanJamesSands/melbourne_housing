library(leaflet)
library(rgdal)
library(RColorBrewer)
library(htmltools)

#plot localites
locs <-  readOGR('other_data/VIC_LOCALITY_POLYGON_shp.shp',GDAL1_integer64_policy = TRUE,stringsAsFactors = F)
locs$VIC_LOCA_2 <- capitalize(tolower(locs$VIC_LOCA_2))

#locs$VIC_LOCA_2 has suburb names

#property_data <- property_data[1:1000,]
suburb_data <- group_by(property_data,suburb) %>% summarise(
    median_price = median(price,na.rm=T),
    q25 = quantile(price,0.25,na.rm=T),
    q75 = quantile(price,0.75,na.rm=T),
    mean_lng = mean(lng,na.rm=T),
    mean_lat = mean(lat,na.rm=T),
    count0 = n(),
    count = sum(!is.na(price))
    )

locs_small <- locs[which(locs$VIC_LOCA_2 %in% levels(suburb_data$suburb)),]


#merge data from suburb_data to locs_small
merged <- merge(locs_small,suburb_data,by.x='VIC_LOCA_2',by.y='suburb')

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
pal <- colorNumeric('Reds',domain=range(merged$median_price,na.rm=T))
leaflet(merged) %>% addTiles() %>% 
    addPolygons(fillColor = ~pal(median_price),
                fillOpacity = 1,
                weight=1,
                label=~lapply(string,HTML)
                )



#pal <- colorQuantile(c('red','blue'),domain=range(property_data$price,na.rm=T),n=9)
#pal <- colorNumeric('Blues',domain=range(suburb_data$median_price,na.rm=T))
#leaflet(suburb_data) %>% addTiles()  %>% addPolygons(lat=~mean_lat,lng=~mean_lng,color = ~pal(median_price),
#                                                      opacity=1,fillOpacity = 1,radius =0.01 )

#leaflet(locs) %>% addPolygons()
