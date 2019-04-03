suburbs = unique(d$suburb)
suburb_counts = sapply(suburbs,function(x){sum(d$suburb==x)})
names(suburb_counts) <- suburbs
mean(suburb_counts)
#an average of 99 sales per suburb might be enough
#handle the low counts tho
#maybe use number of sales in a suburb as a feature, will the model self regularise?
#maybe some interaciton between number of sales and mean price in suburb

sub_suburb_count = tail(sort(suburb_counts),30)
barplot(sub_suburb_count,las=2)
#text(x=(1:10)*-0.5,y=100,srt=90,names(sub_suburb_count))
