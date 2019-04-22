#set up colors
N = nrow(train0)
col <- rgb(0,0,0,0.3)
#col_vec <- rep(col,N)


#pars
FRAC_TO_BUILD <- 0.3
NUM_GRID_PTS <- 1000
feature <- 'dist_cbd'
centre <- FALSE
#colorby <- xgb_train0_x$nbathroom %>% standar
#colfac <- (xgb_train0_x$year_built> median(xgb_train0_x$year_built))*1
#col_vec <- rgb(colfac,0,1-colfac,0.5)
col <- rgb(0,0,0,0.4)
col_vec <- rep(col,N)
#
ice_plot <- function(model,X,y,XGB=T,feature,centre=FALSE,cent_perc=0,frac_to_build=0.1,
                     num_grid_pts=1000,alpha=0.5,col_vec=NULL) {
    if(is.null(col_vec)) {
        col <- rgb(0,0,0,alpha)
        col_vec <- rep(col,N)
    }
    #randomise the X value to be fair about the overplotting , 
    #(just in case there is a relationship between the index and the feature
    #values)
    X <- X[sample(1:nrow(X),nrow(X)),]
    
    if(XGB) {
        featnum <- which(colnames(X)==feature) 
    } else {
        featnum <- which(names(X)==feature)        
    }

    ice_obj = ice(model,
                  X = X,
                  y = y,
                  predictor=featnum,
                  verbose=F,
                  num_grid_pts = num_grid_pts,
                  frac_to_build = frac_to_build
    )
    plot(ice_obj,plot_orig_pts_preds = F,colorvec = col_vec,centered = centre,xlab=feature,centered_percentile=cent_perc)
}

stand_range <- function(vec) {
    (vec - min(vec)) / (max(vec) - min(vec))
}
