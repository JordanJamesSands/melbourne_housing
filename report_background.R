#has_na <- !complete.cases(property_data)
#noprice <- is.na(property_data$price)
#sum_dropped <- sum(has_na) - sum(noprice)
#sum_has_price <- sum(!noprice)
#prop_noprice_in_na <- mean(which(has_na) %in% which(noprice))
#prop_dropped_in_hasprice <- sum_dropped / sum_has_price

#perc_noprice_in_na <- paste0(round(100*prop_noprice_in_na,2),'%')
#perc_dropped_of_that_with_price <- paste0(round(100*prop_dropped_in_hasprice,2),'%')


#try again
#sum_no_price <- sum(is.na(property_data$price))
#sum_has_na <- sum(!complete.cases(property_data))
#prop_noprice_hasna <- sum_no_price / sum_has_na
#number_of_price_entries_with_na <-  sum_has_na - sum_no_price
#num_ent <- nrow(property_data)
#num_ent_with_price <- num_ent - sum_no_price
#prop_of_data_with_price_that_is_dropped <- number_of_price_entries_with_na / num_ent_with_price




has_na <- !complete.cases(property_data)
has_price <- !is.na(property_data$price)
dropped_after_droppoing_price <- has_na & has_price
prop_dropped_after_dropping_price <- sum(dropped_after_droppoing_price) / sum(has_price)

prop_no_price_in_na = mean(!has_price/has_na)


