myplot <- function(varname) {
    plot(train[[varname]],log(train$price),pch=19,col=rgb(0,0,0,0.2))
}

vars = c('nrooms','type','method','date','precomputeddist','nbedroom',
         'nbathroom','ncar','land_area','building_area','year_built',
         #'council_area',
         'lat','lng','region','propcount')
for (var in vars) {
    print(var)
    myplot(var)
    title(var)
}
