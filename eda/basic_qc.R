d[which(d$nbedroom == 20),]$price
#this seems very low
#look closer, 1 bathroom, this is no house

mean(d$price,na.rm = T)
#this seems reasonable
d[which(d$nbedroom == 16),]$price
#this make more sense

#only 78% of prices available
1-mean(is.na(d$price))

#check median prices, compared with 
#https://reiv.com.au/property-data/premium-research#median

#reiv DEC 18 median, Toorak: 809000 
median(subset(d,suburb=='Toorak')$price,na.rm=T)
#reiv DEC 18 median, Elwood: 625000
median(subset(d,suburb=='Elwood')$price,na.rm=T)
#reiv DEC 18 median, Port Melbourne: 801000
median(subset(d,suburb=='Port Melbourne')$price,na.rm=T)
#reiv DEC 18 median, Northcote: 553500
median(subset(d,suburb=='Northcote')$price,na.rm=T)
#reiv DEC 18 median, Essendon: 530000
median(subset(d,suburb='Essendon')$price,na.rm=T)

names <- c('Toorak','Elwood','Port Melbourne','Northcote','Essendon')
reiv_vector = c(809000,625000,801000,553500,530000)
my_vector <- c(1005000,717000,1190000,1205000,870000)
plot(reiv_vector,my_vector)
cor(my_vector,reiv_vector)

