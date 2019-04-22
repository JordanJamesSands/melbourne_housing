search_dist=1000
east_boundary = destPoint(c(kewlng,kewlat),90,search_dist)[1,1]
north_boundary = destPoint(c(kewlng,kewlat),0,search_dist)[1,2]
south_boundary = destPoint(c(kewlng,kewlat),180,search_dist)[1,2]
west_boundary = destPoint(c(kewlng,kewlat),270,search_dist)[1,1]

mat = matrix(c(west_boundary,south_boundary,east_boundary,north_boundary),nrow=2)
rownames(mat) <- c('x','y')
colnames(mat) <- c('min','max')

#polygon = Polygon(coords)
