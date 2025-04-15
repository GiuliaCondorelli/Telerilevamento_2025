# R code for Principal Component Analysis

library(imageRy)
library(terra)

im.list()

sent= im.import("sentinel.png")
sent=flip(sent)
plot(sent)


sent=c(sent[[1]], sent[[2]], sent[[3]])
plot(sent)

# NIR= band 1
# red = band 2
# green = band 3

sentpca = im.pca(sent)  # posso aggiungere n_samples per stabilizzare i valori


tot= 77+57+5
# 139

# 77:139=x:100
# 77*139/tot(100)

sdpc1=focal(sentpca[[1]], w=c(3,3), fun="sd")
plot(sdpc1)

pairs(sent)  # per fare correlazione tra le varie bande
