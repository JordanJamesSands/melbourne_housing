#explore properties without any bathrooms or bedrooms
no_beds = subset(d,nbedroom==0)
View(no_beds)
no_baths = subset(d,nbathroom==0)
View(no_baths)
mean(d$nbedroom==0 | d$nbathroom==0,na.rm=TRUE)
#only 0.2 % fit this strange occurence
#are they garages?
no_beds_baths = subset(d,nbathroom==0 & nbedroom==0)
mean(no_beds_baths$ncar)
#no they are not garages