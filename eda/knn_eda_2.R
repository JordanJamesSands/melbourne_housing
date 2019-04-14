nrooms <- stand_range(knn_train0_x$nrooms)
col_vec <- rgb(nrooms,0,1-nrooms,0.6)
ice_plot(knn_model,as.matrix(knn_train0_x),knn_train0_y,feature='year_built',
         centre=T,cent_perc = 0.1, col_vec = col_vec,frac_to_build = 0.5)
