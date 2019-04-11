has_school = train0$nschool_2000 > 0
plot(train0[has_school,]$school_min_dist,log(train0[has_school,]$price),col=rgb(train0[has_school,]$nrooms>3,0,0))
