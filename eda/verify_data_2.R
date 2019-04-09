#parse government data
gov_median_data <- read.csv('other_data/suburb_house_2017_edited.csv',stringsAsFactors = F)
names(gov_median_data)[1] <- 'suburb'
gov_median_data$suburb <- gov_median_data$suburb %>% tolower %>% capitalize

#limit property_data to 2017
property_data_2017 <- subset(property_data,date<'2018-01-01' & date > '2016-12-31')
#limit to houses
property_data_2017 = property_data_2017[property_data_2017$type=='h',]


#select relevant columns
gov_median_data =  gov_median_data %>% select(c(suburb,X2017))
#rename column
names(gov_median_data)[2] <- 'median_price'
property_data_2017 <- group_by(property_data_2017,suburb) %>% 
    summarise(median_price = median(price,na.rm=T),count=n())

#record how many properties were sold in this area, compared to total
property_data_2017$prop <- property_data_2017$count/sum(property_data_2017$count)

comparison_data = merge(property_data_2017,gov_median_data,by='suburb',suffixes = c('_pd','_gov'))


plot_ly(data=comparison_data,
        x=~median_price_gov,
        y=~median_price_pd,
        type='scatter',
        mode='markers',
        text=paste0(comparison_data$suburb,'\n',comparison_data$count,' sales'),
        hoverinfo='text'
) %>% add_lines(x=c(0,4e+6),y=c(0,4e+6),inherit = F) %>%
    layout(showlegend=F,
           xaxis=list('title'='Median Sale Price in our Dataset'),
           yaxis=list('title'='Median'))

