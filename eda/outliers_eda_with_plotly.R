library(dplyr)
library(plotly)

#removing outliers
#were gonna limit the scope of the analysis to properties with a specific number of bed n baths, this is necesary since we dont have a lot of data
BATHLIMIT = 3
ROOMLIMIT =5

#maybe roomlimit 5 and bathlimit 3

with(d,plot(jitter(nrooms),jitter(nbathroom),pch=19))
with(d,plot(nrooms,nbathroom,pch=19))
abline(v=ROOMLIMIT)
abline(h=BATHLIMIT)

#just make a table, this removes the overplotting issue
tb_count = table(d$nrooms,d$nbathroom)
df_count = as.data.frame(tb)
names(df_count) = c('nrooms','nbathroom','freq')
#unfactor
df_count$nrooms = df_count$nrooms %>% as.character %>% as.numeric
df_count$nbathroom = df_count$nbathroom %>% as.character %>% as.numeric


plot_ly(df_count,x=~nrooms,y=~nbathroom,z=~freq)
#lets remove the extremes
plot_ly(subset(df_count,nrooms<=10 & nbathroom<=6),x=~nrooms,y=~nbathroom,z=~freq)


#DF with no NAS in nbedroom or nbathroom
complete_bed_bath = subset(d,!is.na(nrooms) & !is.na(nbathroom))
cc = with(complete_bed_bath,
          mean(nbathroom <= BATHLIMIT & nrooms <= ROOMLIMIT)
)
print(paste('proportion of complete cases:',cc))

