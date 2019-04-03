library(VennDiagram)
vd <- venn.diagram(list(A=c(1,2,3),B=c(2,3,4)),filename=NULL)
grid.draw(vd)
plot.new()



feats <- c('nbathroom','ncar','land_area','building_area')

na_list <- lapply(feats,function(feat){which(is.na(property_data[[feat]]))})
names(na_list) <- feats
plot.new()
vd <- venn.diagram(na_list[1:5],filename=NULL)
grid.draw(vd)


feats <- c('date','nrooms','type','nbathroom','ncar',
           'suburb','price','method','land_area','building_area',
           'year_built','lat','lng','region')
na_feats <- c('nbathroom','ncar','price','land_area','building_area',
              'year_built','lat','lng')
for (feat in feats) {
    print(feat)
    print(sum(is.na(property_data[[feat]])))
}
#8214 appears alot

with(property_data,sum(is.na(suburb) | is.na(nbathroom) | is.na(method) | is.na(region) | is.na(nrooms) ))



with(property_data,
     sum(
        is.na(nbathroom) | is.na(ncar)  | is.na(lat) | is.na(lng)
    )
)




#no_bath_nas <- subset(property_data,!is.na(nbathroom))

#for (feat in na_feats) {
#    print(feat)
#    print(sum(is.na(no_bath_nas[[feat]])))
#}
