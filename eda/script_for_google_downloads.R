#download api data
#ensure at correct place in pipeline
#dont save the output to memory, it will save to disk
listout = download_google_api_data(property_data[1:1000,],'park')
listout = download_google_api_data(property_data,'school')
listout = download_google_api_data(property_data,'supermarket')
listout = download_google_api_data(property_data,'kindergarten')