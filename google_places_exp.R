req_string = google_places('park',location=sort(MELBOURNE_CENTRE),key=PRIVATE_KEY,radius=10000)
req_keyword = google_places(keyword='park',location=sort(MELBOURNE_CENTRE),key=PRIVATE_KEY,radius=10000)
req_place_type = google_places(place_type='park',location=sort(MELBOURNE_CENTRE),key=PRIVATE_KEY,radius=10000)


names(req_keyword)
names(req_string)

d1 = req_keyword$results
d2 = req_string$results

n1 = names(d1)
n2 = names(d2)
all = union(n1,n2)

notin1 = all[!(all %in% n1)]
notin2 = all[!(all %in% n2)]

