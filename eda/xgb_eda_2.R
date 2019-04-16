#there is a lack of intereaction between age and nrooms, not what i expected?

#am_nrooms <- (xgb_train0_x$nrooms > median(xgb_train0_x$nrooms))*1
#col_vec <- rgb(am_nrooms,0,1-am_nrooms,0.2)
nrooms <- stand_range(xgb_train0_x$nrooms)
col_vec <- rgb(nrooms,0,1-nrooms,0.2)
ice_plot(xgb_model,as.matrix(xgb_train0_x),xgb_train0_y,feature='year_built',
         centre=T,cent_perc = 0.1, col_vec = col_vec,frac_to_build = 0.5)


ice_plot(xgb_model,as.matrix(xgb_train0_x),xgb_train0_y,XGB=T,feature='bearing',frac_to_build = 0.1)
