library(RColorBrewer)

median_data <- read.csv('other_data/suburb_house_2017_edited.csv')
names(median_data)[1] <- 'suburb'
d_2017 <- subset(property_data,date<'2018-01-01' & date > '2016-12-31')

#change suburb cases to lower
median_data$suburb = tolower(median_data$suburb)
d_2017$suburb = tolower(d_2017$suburb)

#select relevant columns
median_data =  select(median_data,c(suburb,X2017))
d_2017 <- group_by(d_2017,suburb) %>% summarise(median_price = median(price,na.rm=T),count=n())
d_2017$prop <- d_2017$count/sum(d_2017$count)

#change names
md = median_data
d2 = d_2017

#remove other suburbs from md
both_subs = intersect(md$suburb,d2$suburb)
md <- subset(md,suburb %in% both_subs)
d2 <- subset(d2,suburb %in% both_subs)

pal = display.brewer.pal(n=9,name='YlOrRd')

plot(md$X2017,d2$median_price,
     col=rgb(0,0,0,0.5),
     pch=19,
     xlab='Government Median Data per suburb 2017',
     ylab='Medians for sales in 2017, computed from project data'
)
abline(0,1)
plot(md$X2017,d2$median_price,
     col=rgb(0,0,0,0.5),
     pch=19,
     xlab='Government Median Data per suburb 2017',
     ylab='Medians for sales in 2017, computed from project data'
     )
abline(0,1)
#insert data showing number of sales used for median computation
text(md$X2017+2e5,d2$median_price-2e4,paste0(d2$suburb,',',d2$count,' sales'),cex=0.5)

plot(md$X2017,d2$median_price,
     col=rgb(0,0,0,0.5),
     pch=19,
     xlab='Government Median Data per suburb 2017',
     ylab='Medians for sales in 2017, computed from project data'
)
abline(0,1)
#insert data showing number of sales used for median computation
text(md$X2017+1e5,d2$median_price-2e4,d2$suburb,cex=0.5)

#there coulb be a relationship between house price and the domain/government
#discrepancy


#from all data, (not just 2017)
plot(sort(d[d$suburb=='Toorak',]$price))
abline(h=median(d[d$suburb=='Toorak',]$price,na.rm=T))



