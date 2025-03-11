#code to calculate spectral indices from satellite images

library(imageRy)  
library(terra)
library(viridis)


im.list()

mato1992=im.import("matogrosso_15_1992219_lrg.jpg")
mato1992=flip(mato1992)

# 1=NIR
# 2=red
# 3=green

im.plotRGB(mato1992,r=1,g=2,b=3)
