terms_to_plot <- c("s(building_area_log, df = 20)" ,"s(dist_cbd, df = 10)" , "s(bearing, df = 28)" ,"s(year_built, df = 15)"   )
plot(gam_model,terms = terms_to_plot)

train0_gam <- train0_gam_unscaled
train0_gam <-lapply(train0_gam , function(col) {
    if(is.numeric(col)) {
        return(scale(col))
    } else {return(col)}
}) %>% as.data.frame

