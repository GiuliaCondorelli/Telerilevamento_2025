# Exam project title: title

## Data gathering

data were gathered from the [Earth Observatory site] (https://earthobservatory.nasa.gov/).

Packages used:

` ` `r
library(terra)
library(imageRy)
library(viridis) # in order to plot 
` ` ` 
setting the working directory and importing the data:

` ` ` r
setwd("~//")    tra gli slash devi mettere la tua working directory 
fires=rast("fires.jpg")
plot(fires)
fires= flip(fires)
plot(fires)
` ` ` 

the image is the following:



##Data analysis

Based on the data gathered frome the site we can calculate an index, using the first two bands:

` ` ` r
plot("fireindex.png")
plot(fireindex)
dev.off()
` ` ` 

the index looks like



## index visualisation by viridis

in order to visualize the index with another viridis oalette we made use of the following code:

` ` ` r
library(viridis)
plot(fireindex, col=inferno(100))
` ` ` 
the output will look like:

