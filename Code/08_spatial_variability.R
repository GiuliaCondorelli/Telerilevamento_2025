
# Code fore calculating spatial variability

library(terra)
library(imageRy)
library(viridis)
library(patchwork)
library(RStoolbox)

#Theory
#Standard deviation
23,22,23,49

m = (23+22+23+49) / 4  #media
m=29.25

#variability
num = (23-29.25)^2 + (22-29.25)^2 + (23-29.25)^2 + (49-29.25)^2 #scarto quadratico
den = 4
variance = num / den #scarto quadratico medio
stedv = sqrt (variance) #deviazione standard
stedv =11.41271

#or
sd (c(23,22,23,49))

im.list()
sent = im.import("sentinel.png")
sent= flip(sent)

#band 1 = NIR
#band 2 = red
#band 3 = green

#Exercise: plot the image in RGB whit the NIR ontop of the red component
im.plotRGB(sent, r=1, g=2, b=3)

#Exercise: make three plots with NIR ontop of each component: r, g, b
im.multiframe(1,3)

im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(sent, r=2, g=1, b=3)
im.plotRGB(sent, r=3, g=2, b=1)

nir= sent[[1]]
plot(nir)

Exercise: plot the NIR band with the inferno color ramp palette
plot(nir, col=inferno(100))
sd3 = focal(nir, w=c(3,3), fun=sd)
plot(sd3)

im.multiframe(1,2)
im.plotRGB(sent, r=1, g=2, b=3)
sd3 = focal(nir, w=c(3,3), fun=sd)
plot(sd3)

#Exercise: calculates standard deviation of the nir band whit a moving window of 5x5 pixels
sd5 = focal(nir, w=c(5,5), fun=sd)
plot(sd5)

#Exercise: use ggplot to plot the standard deviation
im.ggplot(sd3)

#Exercise: plot the two sd maps (3 and 5) one beside the other whit ggplot
p1 = im.ggplot(sd3)
p2 = im.ggplo(sd5)
p1 + p2

#Exercise: whit ggplot, plot the original set in RGB (ggRGB) togheter with the sd with 3 and 5 pixels
p3= ggRGB(sent, r=1, g=2, b=3)
p3 + p1 + p2

#What to do in case of huge images
sent = im.import("sentinel.png")
sent= flip(sent)
plot(sent)
ncell(sent) 

ncell(sent) * nlyr(sent)
#794 * 798
#2534448

senta = aggregate (sent, fact=2)
ncell(senta) * nlyr(senta)
#633612

senta5 = aggregate (sent, fact=5)
ncell(senta5) * nlyr(senta5)
#101760

#Exercise:  make a multiframe and plot in RGB the three images (original, factor 2 and factor 5)
im.multiframe(1,3)
im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(senta, r=1, g=2, b=3)
im.plotRGB(senta5, r=1, g=2, b=3)

#Calculating standard deviation
nira = senta[[1]]
sda3a = focal(nira, w=c(3,3), fun="sd")

#Exercise: calculate the standard deviation for the factor 5 image
nira5 = senta5[[1]]
sd3a5 = focal(nira5, w=c(3,3), fun="sd")

sda5a5 = focal(nira5, w=c(3,3), fun="sd")
plot(sd5a5)

im.multiframe(2,2)
plot(sd5a5)
plot(sd3a)

sent = im.import("sentinel.png")
sent= flip(sent)
nir= sent[[1]]
plot(nir)

sd3 = focal(nir, w=c(3,3), fun=sd)
plot(sd3)


im.multiframe(2,2)
plot(sd3)
plot(sd3a)
plot(sd3a5)
plot(sd5a5)

p1 = im.ggplot(sd3, col=plasma(100))
p2 = im.ggplot(sd3a, col=plasma(100))
p3 = im.ggplot(sd3a5, col=plasma(100))
p4 = im.ggplot(sd5a5,col=plasma(100))

p1 + p2 p3 + p4

#Variance
#nir
var3 = sd3^2

dev.off()
plot(var3)

im.multiframe(1,2)
plot(sd3)
plot(var3)

sd5 = focal(nir, w=c(5,5), fun="sd")
var5 = sd5^2
plot(sd5)
plot(var5)
