library(grid)
library(VennDiagram)
###---------------------------EDA-------------------------------------
sapply(property_data,function(col){mean(!is.na(col))})
sapply(property_data,function(col){sum(is.na(col))})

#interesting columns with regards to NA
int_cols = c('nbathroom','building_area','land_area','lat','ncar') #(lng and lat have same NAs)


#create a list of which elements are NA for each of int_cols
na_list = lapply(int_cols,function(col){which(is.na(property_data[[col]]))})
names(na_list) <- int_cols

plot.new()
vd <- venn.diagram(na_list,
                   width=5000,
                   heiht=5000,
                   filename='na_venndiagram.png',
                   imagetype = 'png',
                   margin=0.1,
                   lty=0,
                   cat.fontfamily='sans',
                   fontfamily='sans',
                   fill = c('red','yellow','blue','green','purple')
)
grid.draw(vd)
