t <- select(property_data,-c(add,council_area))
for (var in names(t)) {
    print(var)
    plot(property_data[[var]],log(property_data$price),
         col=rgb(0,0,0,0.2),
         pch=19,
         main=var
         
    )
}

plot(log(property_data[['land_area']]),log(property_data$price),
     col=rgb(0,0,0,0.2),
     pch=19
)
plot(log(property_data[['building_area']]),log(property_data$price),
     col=rgb(0,0,0,0.2),
     pch=19
)
