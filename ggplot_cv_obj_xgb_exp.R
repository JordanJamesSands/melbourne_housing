eval_log <- cv_obj$evaluation_log

ggplot(eval_log,aes(x=iter)) + 
    coord_cartesian(ylim=c(0.1,0.4)) +
    geom_line(aes(y=train_rmse_mean),lwd=2,col='#0078D7') +
    geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
    geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
    geom_line(aes(y=test_rmse_mean),lwd=2,col='orange') +
    geom_line(aes(y=test_rmse_mean + test_rmse_std),lwd=1,col='orange',lty=2) +
    geom_line(aes(y=test_rmse_mean - test_rmse_std),lwd=1,col='orange',lty=2) 
    #geom_hline(yintercept =  min(eval_log$test_rmse_mean),lty=2,lwd=1) 
    #geom_vline(xintercept = which.min(eval_log$test_rmse_mean))
    #geom_hline(yintercept =  min(eval_log$test_rmse_mean) - eval_log$test_rmse_std[cv_obj$best_iteration],lty=2) +
    #geom_hline(yintercept =  min(eval_log$test_rmse_mean) + eval_log$test_rmse_std[cv_obj$best_iteration],lty=2) 

