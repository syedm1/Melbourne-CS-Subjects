library(sp)
library(raster)
library(spatstat)
library(maptools)
library(plotrix)

data <- read.csv("http://www.fabioveronesi.net/Blog/2014-05-metropolitan-street.csv")

data <- data[!is.na(data$Longitude)&!is.na(data$Latitude),]

coordinates(data) = ~Longitude + Latitude

zero <- zerodist(data)
length(unique(zero[,1]))

# download.file("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip",destfile="ne_10m_admin_1_states_provinces.zip")
# unzip("ne_10m_admin_1_states_provinces.zip",exdir="NaturalEarth")
border <- shapefile("NaturalEarth/ne_10m_admin_1_states_provinces.shp")
GreaterLondon <- border[paste(border$region)=="Greater London",]

projection(data)=projection(border) 
overlay <- over(data,GreaterLondon) 
data$over <- overlay$OBJECTID_1 
data.London <- data[!is.na(data$over),]

jpeg("PP_plot.jpg",2500,2000,res=300)
plot(data.London,pch="+",cex=0.5,main="",col=data.London$Crime.type)
plot(GreaterLondon,add=T)
legend(x=- 0.53,y=51.41,pch="+",col=unique(data.London$Crime.type), legend=unique(data.London$Crime.type), cex=0.4)
