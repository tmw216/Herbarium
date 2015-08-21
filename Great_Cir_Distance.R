##############################################################
##############  Great Circle Distance Coding    ##############
##                Date:  August 21, 2015                    ##
##                Using tmw computer                        ##
##############################################################
##############################################################

## Clear memory
rm(list=ls())

library(fields)

## Load in data sets 
load("../obs/20100831_StationData/20100831_ObservedStationData.Rdata") # Obs + Station data sets
station = station  # 2621 obs of 9 var 'lat/lon'
obs = obs   # 22634312 obs of 5 var NO 'lat/lon'
herb <- read.csv(file="../HerbFinal.csv", header=TRUE, na.string='.') # Herb + Schulze -- 750 obs of 26 var

## Change col names
colnames(herb)[which(names(herb) == "Latitude")] <- "lat"
colnames(herb)[which(names(herb) == "Longitude")] <- "lon"

## Station (x1): matrix of lon then lat
stationmx <- as.matrix(station[,3:4])

## Herbarium (x2): matrix of lon then lat
herbmx <- as.matrix(herb[,18:17])

## WORKS THE BEST-->  rows=herbarium      cols=weather stations
distance <- rdist.earth(herbmx, stationmx, miles=FALSE, R=6371) ## in kilometers

write.csv(distance, file = "distance.csv")

###### Melt Distance matrix to get distance values out ######

## Make into a data.frame
distance <- as.data.frame( distance )

## Assign population names now
Herb <- paste( "Stations", 1:2621, sep = "_" )
names( distance ) <- Herb 
distance$Herb <- paste("Herb", 1:497, sep = "_") ## adding col header

## Melt this matrix
library(reshape)
dist.melt <-
  melt( distance , id.vars="Herbs" )

str(dist.melt)  ## value = number 
summary(dist.melt)

write.csv(dist.melt, file = "melt.csv")