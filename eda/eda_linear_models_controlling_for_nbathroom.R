#study interactions between bedroom and bathroom

#mod <- glm(log(price) ~ nbedroom * nbathroom,data=d)
#summary(mod)


#this mimicks the plots in eda1
d_cropped <- subset(d,nbedroom<10 & nbathroom<6)

#THESE MODELS ASSUME A LINEAR EFFECT OF BATHROOM AND BEDROOM
#DONT GET CARRIED AWAY, THIS IS EDA

for (i in 1:5) {
    print(paste('num bathrooms = ',i))
    subdata = subset(d_cropped,nbathroom==i)
    print(paste('num obs = ',dim(subdata)[1]))
    print(summary(glm(log(price) ~ nbedroom, data=subdata))$coef)
    cat('\n\n')
}

#the effect of bedrooms on price for props with 4 bathrooms appears negative but the CI is quite large, maybe just an outlier
