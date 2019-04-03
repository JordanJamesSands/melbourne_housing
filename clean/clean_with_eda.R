library(grid)
library(VennDiagram)

#--------------------------remove outliers------------------------------------
bath_bool <- is.na(property_data$nbathroom) | (property_data$nbathroom<=4 & property_data$nbathroom>0)
nroom_bool <- is.na(property_data$nrooms) | (property_data$nrooms<=6 & property_data$nrooms>0)
property_data <- property_data[nroom_bool & bath_bool,]

###---------------------------EDA-------------------------------------
tmp <- property_data %>% select(c(date,nrooms,type,nbathroom,ncar,suburb,price,method,
                                            land_area,building_area,year_built,lat,lng,region))
sapply(tmp,function(col){mean(!is.na(col))})
sapply(tmp,function(col){sum(is.na(col))})

#interesting columns with regards to NA
int_cols = c('nbathroom','ncar','land_area','lat') #(lng and lat have same NAs)


#create a list of which elements are NA for each of int_cols
na_list = lapply(int_cols,function(col){which(is.na(tmp[[col]]))})
names(na_list) <- int_cols

plot.new()
vd <- venn.diagram(na_list,
                   filename=NULL,
                   fill = c('red','yellow','blue','green'),
                   cex=1
)
grid.draw(vd)

#-------------------- data dropping justification ------------------------------------
#nbathroom is a significant predictor, and accosiated with many other nas, drop it

#we can see that there are 7943 NAs in common with all, lets drop these, as well 
    #as other entries where nbathroom is na
#nbathroom has a significant impact on price, see eda_linear_models_2.R
#The following plot suggests it may be difficult to impute nbathroom, correlation with nroom is low.
with(property_data,plot(jitter(nbathroom),jitter(nrooms),pch=19,col=rgb(0,0,0,0.2)))
bool = !is.na(d$nbathroom) & !is.na(d$nrooms)
cor(d$nbathroom[bool],d$nrooms[bool])
#nbathroom
#dont impute, exploratory linear models suggest this has a significant 
#impact, there are only 271 missing anyway

#-----------------------------drop rows
drop_rows <- is.na(property_data$nbathroom)
property_data <- property_data[!drop_rows,]
