getwd()
setwd('/home/chen184/GEDI')
library(GWmodel)
library(tidyverse)  # Modern data science workflow
library(sf)
library(sp)
library(rgdal)
library(rgeos)
library(tmap)
library(tmaptools)
library(grid)
library(gridExtra)
library(car)
list.files()

t <- readOGR(".", "ForestCRS1haV9")
head(t)

#model1 <- lm(Bio ~ STC+DistSettle+DistRoads+SoilN+TC+SoilCEC+Slope+Dem+Cwd+FireF+Age, data = t)
model1 <- lm(Bio ~ STC+DistRoads+SoilN+TC+SoilCEC+Slope+Dem+Cwd+FireF+Age, data = t)

#t - subset(t,t$area<10)
summary(model1)
#m <- mean(t$Biomass)
#sd <- sd(t$Biomass)
#m
#sd
#t$Bio <- (t$Biomass-m)/sd

car::vif(model1)
set.seed(123)
t
DM<-gw.dist(dp.locat=coordinates(t))
#DM
#write.csv(DM,'DM2019withSettle.csv')
######################Adaptive  Gaussian /Bisquare

bw2 <- 100
gwr.res2<-gwr.basic(Bio ~ Age+Cwd+Dem+FireF+DistRoads+Slope+SoilCEC+SoilN+STC+TC, data=t, bw=bw2,adaptive=TRUE,kernel = "gaussian", dMat=DM, parallel.method = "omp")
saveRDS(gwr.res2, file = "FinalY2019Ada.rds")
mod <- readRDS("FinalY2019Ada.rds")
mod
write.csv(results2,'FinalY2019Ada.csv')
writeOGR(gwr.res2$SDF, ".", "FinalY2019Ada", driver = "ESRI Shapefile")

