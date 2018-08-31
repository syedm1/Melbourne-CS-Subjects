library(sp)
library(maptools)
library(rgdal)
library(ggplot2)
library(ggmap)
library(classInt)
library(RColorBrewer)

eurMap <- readOGR(dsn="CNTR_2010_60M_SH/shape/data/", "CNTR_RG_60M_2010")

eurEdu <- read.csv('educ_thexp_1_Data.csv',stringsAsFactors=F)

plot(eurMap)

eurMapDf <- fortify(eurMap,region="CNTR_ID")
ggplot(eurMapDf) + aes(long,lat,group=group) + geom_polygon()

eurEduMapDf <- merge(eurMapDf,eurEdu, by.x='id', by.y='GEO')
europe.limits <- geocode(c("Cape Fligely, Franz Josef Land, Russia", "Gavdos, Greece", "Faja Grande, Azores", "Severny Island, Novaya Zemlya, Russia"))
eurEduMapDf <- subset(eurEduMapDf, long > min(europe.limits$lon) & long < max(europe.limits$lon) & lat > min(europe.limits$lat) & lat < max(europe.limits$lat))
ggplot(eurEduMapDf)+aes(long,lat,group=group,fill=Value)+geom_polygon()

ggplot(eurEduMapDf,aes(long,lat,group=group,fill=Value)) + geom_polygon() + coord_map("conic", lat0 = 30)

intervals <- classIntervals(eurEduMapDf$Value, n=10, style="equal")
rank <- findInterval(intervals$var,intervals$brks)
eurEduMapDf$rank <- rank
ggplot(eurEduMapDf) + aes(long,lat,group=group,fill=rank)+geom_polygon()

ggplot(eurEduMapDf) + aes(long,lat,group=group,fill=rank) + geom_polygon() + scale_fill_continuous(guide="legend")

m0 <- ggplot(eurEduMapDf)
m1 <- aes(long,lat,group=group,fill=rank)
m2 <- geom_polygon()
m3 <- scale_fill_continuous(guide="legend")

eurEduMapDf$rank <- as.factor(rank)
m0 + m1 + m2 + scale_fill_brewer(type="seq",palette=7)
m0 + m1 + m2 + scale_fill_brewer(type="seq",palette=7) + geom_path(color='dark grey')
m0 + m1 + m2 + scale_fill_brewer(type="seq",palette=7) + geom_path(color='dark grey') + theme(panel.background = element_rect(fill="white"))
