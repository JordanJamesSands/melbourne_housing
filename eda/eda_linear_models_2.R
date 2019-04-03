model <- glm(log(price) ~ nrooms + nbathroom + ncar + lat + lng + land_area + building_area,
             data=property_data)
summary(model)$coef
#interesting that ncar doesnt have a major impact
#also nrooms doesnt either
plot(model)

