plot_xgb_ice <- function(model,X,y,feature) {
    colour <- rep(rgb(0,0,0,0.05),nrow(X))
    ice_obj = ice(model,
                  X=as.matrix(X),
                  y=y,
                  predictor=which(feature == names(X)),
                  verbose=F,
                  frac_to_build=1)
    plot(ice_obj,plot_orig_pts=F,colorvec=colour,xlab=feature)
}
plot_xgb_ice(xgb_model , xgb_train0_x,xgb_train0_y,'building_area')
plot_xgb_ice(xgb_model , xgb_train0_x,xgb_train0_y,'dist_cbd')
plot_xgb_ice(xgb_model , xgb_train0_x,xgb_train0_y,'bearing')
plot_xgb_ice(xgb_model , xgb_train0_x,xgb_train0_y,'year_built')