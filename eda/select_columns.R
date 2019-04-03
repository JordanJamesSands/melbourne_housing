library(dplyr)
columns_to_use = c('nrooms','type','method','precomputeddist','nbathroom',
                   'ncar','land_area','building_area','year_built','lat','lng',
                   'region','propcount','imputed_year_built','imputed_ncar',
                   'imputed_land_area','imputed_building_area','price')

num_columns_to_use = c('nrooms','precomputeddist','nbathroom',
                   'ncar','land_area','building_area','year_built','lat','lng',
                   'propcount','imputed_year_built','imputed_ncar',
                   'imputed_land_area','imputed_building_area','price')


select_cols <- function(df,numeric_only=FALSE) {
    if (!numeric_only) {return (select(df,columns_to_use))}
    else {return(select(df,num_columns_to_use))}
}