# Code for calculating spatial variability

library(terra)
library(imageRy)


# Theory: 

# Standard deviation
23, 22, 23, 49

m = (23 + 22 + 23 + 49) / 4
# m = 29.25

num = (23-29.25)^2 + (22-29.25)^2 + (23-29.25)^2 + (49-29.25)^2     # estraiamo la somma di tutti gli scarti quadratici
den=4

variance = num/den  # è lo scarto quadratico medio
stdev = sqrt(variance)
# stdev = 11.41271

sd(c(23, 22, 23))

#---

im.list()

sent = im.import("sentinel.png")

# band 1 = NIR
# band 2 = red
# band 3 = green
# Exercise plot the image in RGB with the NIR on top of the red component
im.plotRGB(sent, r=1, g=2, b=3)

# Exercise: make three plots with NIR on top of each component: r, g, b
im.multiframe(1,3)
