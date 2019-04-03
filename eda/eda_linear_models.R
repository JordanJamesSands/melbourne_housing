#linear model
model = glm(log(price) ~ nrooms + nbedroom + nbathroom + ncar, data=property_data)
summary(model)$coef


bool = !is.na(d$nbedroom) & !is.na(d$nrooms)
cor(d$nbedroom[bool],d$nrooms[bool])
#nrooms is ***significantly correlated*** with nbedrooms
# consider dropping nbedrooms

bool = !is.na(d$nbathroom) & !is.na(d$nrooms)
cor(d$nbathroom[bool],d$nrooms[bool])
#correlation between nrooms and nbathrooms is lower at 0.6118259

bool = !is.na(d$ncar) & !is.na(d$nrooms)
cor(d$ncar[bool],d$nrooms[bool])
# also low at  0.3938778

