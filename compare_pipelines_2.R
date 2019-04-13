#for comparison of pipelines
identical(train0_4,train0_3) %>% print
all(names(train0_4) == names(train0_3)) %>% print
all(train0_4$ID == train0_3$ID) %>% print
all(sapply(train0_3,class) == sapply(train0_4,class))
for(var in names(train0_4)) {
    #print(var)
    all(train0_4[[var]] == train0_3[[var]]) %>% print
}

for(var in names(train0_4)) {
    #print(var)
    identical(train0_4[[var]],train0_3[[var]]) %>% print
}
