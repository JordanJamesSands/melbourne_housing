sub_medians <- d %>% group_by(suburb) %>% summarise(median_price = median(price,na.rm=T),count = n())
#sort suburbs by how much data we have on them
sub_medians <- sub_medians[order(sub_medians$count,decreasing = T),]

sub_medians_small <- sub_medians[1:10,]



