library(dplyr)
library(plotly)

#removing outliers
#were gonna limit the scope of the analysis to properties with a specific number of bed n baths, this is necesary since we dont have a lot of data
BATHLIMIT = 4
BEDLIMIT =6

with(d,plot(jitter(nbedroom),jitter(nbathroom),pch=19))
with(d,plot(nbedroom,nbathroom,pch=19))
abline(v=BEDLIMIT)
abline(h=BATHLIMIT)

#just make a table, this removes the overplotting issue
tb_count = table(d$nbedroom,d$nbathroom)
df_count = as.data.frame(tb)
names(df_count) = c('nbedroom','nbathroom','freq')
#unfactor
df_count$nbedroom = df_count$nbedroom %>% as.character %>% as.numeric
df_count$nbathroom = df_count$nbathroom %>% as.character %>% as.numeric


plot_ly(df_count,x=~nbedroom,y=~nbathroom,z=~freq)
#lets remove the extremes
plot_ly(subset(df_count,nbedroom<=10 & nbathroom<=6),x=~nbedroom,y=~nbathroom,z=~freq)
#plotly plot suggests cut off nbathrooms at <=3 or 4 and bedrooms at <= 5 or 6


#DF with no NAS in nbedroom or nbathroom
complete_bed_bath = subset(d,!is.na(nbedroom) & !is.na(nbathroom))
cc = with(complete_bed_bath,
    mean(nbathroom <= BATHLIMIT & nbedroom <= BEDLIMIT)
)
    print(paste('proportion of complete cases:',cc))

#plot(jitter(t$nbedroom,2),t$price,pch=19,col=rgb(0,0,0,0.2))
#plot(jitter(t$nbathroom,2),t$price,pch=19,col=rgb(0,0,0,0.2))