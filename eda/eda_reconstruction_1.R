#cleaning

#look at proportion of complete rows
mean(complete.cases(d))
#lets check NAs from our favourite vars
sapply(d,function(col){mean(!is.na(col))})
# of the properties with price data...
sapply(subset(d,!is.na(price)),function(col){mean(!is.na(col))})


#How many properties have no bed and bath count?
mean(is.na(d$nbedroom) & is.na(d$nbathroom))
#thats alot, what about ncars aswell
mean(is.na(d$nbedroom) & is.na(d$nbathroom) & is.na(d$ncar))
#and other vars

mean(is.na(d$nbedroom) & is.na(d$nbathroom)& is.na(d$ncar) & is.na(d$lng) & is.na(d$lat) & is.na(d$land_area) & is.na(d$building_area))
#23% of observations are missing location, beds, baths, garages, land area and building area
missing_alot = is.na(d$nbedroom) & is.na(d$nbathroom)& is.na(d$ncar) & is.na(d$lng) & is.na(d$lat) & is.na(d$land_area) & is.na(d$building_area)
View(subset(d,missing_alot))
#still contains nrooms, method, price , type and suburb
#perhaps this data should just be dropped
dim(subset(d,!missing_alot & !is.na(price)))
#21015 objects could be enough

#Review the columns that missing_alot contains, do we need that extra data?
sum(missing_alot)
length(levels(d$type))
#3 property types, this variable doesnt have many values, the 7950 objects in missing_alot are not neccesary to exploit this data
length(levels(d$method))





