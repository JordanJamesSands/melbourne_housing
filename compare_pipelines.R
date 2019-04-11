(new_prop$imputed_building_area == old_prop$imputed_building_area )%>% all
(new_prop$imputed_land_area == old_prop$imputed_land_area) %>% all
(new_prop$imputed_ncar == old_prop$imputed_ncar) %>% all
(new_prop$imputed_year_built == old_prop$imputed_year_built ) %>% all

cor(new_prop$building_area[new_prop$imputed_building_area==1],old_prop$building_area[old_prop$imputed_building_area==1])
cor(new_prop$land_area[new_prop$imputed_land_area==1],old_prop$land_area[old_prop$imputed_land_area==1])
cor(new_prop$year_built[new_prop$imputed_year_built==1],old_prop$year_built[old_prop$imputed_year_built==1])
cor(new_prop$ncar[new_prop$imputed_ncar==1],old_prop$ncar[old_prop$imputed_ncar==1])
