#script for exploring xgb_model

standar <- function(vec) {
    return( (vec - min(vec) )/ (max(vec)-min(vec)))
}


#set up colors
N = nrow(xgb_train0_x)
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


prednum <- which(names(xgb_train0_x)==feature)
ice_obj = ice(model_all,
              X = as.matrix(xgb_train0_x),
              y = xgb_train0_y,
              

              predictor=prednum,
              
              verbose=T,
              
              num_grid_pts = NUM_GRID_PTS,
              frac_to_build = FRAC_TO_BUILD
              )



plot(ice_obj,plot_orig_pts_preds = F,colorvec = col_vec,centered = centre,xlab=feature)
