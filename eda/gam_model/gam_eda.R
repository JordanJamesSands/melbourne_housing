train0_eda <- polarise(MELBOURNE_CENTRE,train0)

plot(jitter(train0_eda$nschool_2000,2),log(train0_eda$price))
mod <- lm(log(price) ~ nschool_2000,data=train0_eda)
abline(mod)
summary(mod)

form = (log(price) ~ 
            type + #this is a factor
            nrooms +
            nbathroom +
            #factor(nbathroom):factor(nrooms) +
            building_area_log+
            dist_cbd +
            bearing +
            year_built +
            land_area_log+
            nsupermarket_2000 +
            school_min_dist
)

mod <- lm(form,data=train0_eda)
summary(mod)
anova(mod)

gam_model <- gam(form,data=train0_eda)
summary(gam_model)

lm_mod2 <- lm(log(price) ~ . -ID -add -suburb - agent -method -pc -region -council_area -date -precomputeddist -land_area - building_area, train0_eda)
summary(lm_mod2)
anova(lm_mod2)

lm_mod3 <- lm(log(price) ~ nrooms + type +nbedroom + nbathroom + ncar + land_area_log + building_area_log + year_built + lng + lat + propcount +n)