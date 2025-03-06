# R code for visualizing satellite data

library(terra)
library(imageRy)

im.list()


# for the whole course we are going to make use of = instead of <-
# This is based on the following video:
# http://www.youtube.com/watch?v=0JMpKCKH1hM

b2=im.import("sentinel.dolomites.b2.tif")
