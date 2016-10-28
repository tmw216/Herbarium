#### Organizing Weather Station Data ####

## Clear memory
rm(list=ls())

## Load library
library(fields)

## Load in data sets (Obs and Station)
load("C:/"Your Path Here"/20100831_ObservedStationData.Rdata")

## Attaching lat and lon to observations + measurements 
lat <- numeric(nrow(obs))
lon <- numeric(nrow(obs))
for (i in 1:nrow(obs)) {
  lat[i] <- station[station$station==obs$station, c("lat")]
  lon[i] <- station[station$station==obs$station, c("lon")]
}
obs$lat <- lat
obs$lon <- lon


## Loading in herbarium data (750 obs of 26 var)
herb <- read.csv(file="HerbFinal_All.csv", header=TRUE, na.string='.') # Herb + Schulze

## Change col names
colnames(herb)[which(names(herb) == "Latitude")] <- "lat"
colnames(herb)[which(names(herb) == "Longitude")] <- "lon"

## Station (x1): matrix of lon then lat
stationmx <- as.matrix(station[,3:4])

## Herbarium (x2): matrix of lon then lat
herbmx <- as.matrix(herb[,18:17])

## Distance between herbarium pt and weather stations --> rows=herbarium/n=750, cols=weather stations/n=5352 (large distance matrix)
distance <- rdist.earth(herbmx, stationmx, miles=FALSE, R=6371) # in kilometers - radius of earth

## Melt Distance matrix to get distance values out
## Make into a data.frame
distance <- as.data.frame( distance )

## Assign population names now
distance$Herb <- paste("Herb", 1:750, sep = "_") # adding col header
distance <-subset(distance, select=c(2622,1:2621)) # move herb names to the front of the data frame

## Melt matrix - three cols [Herb points, variable=stations, value=km dist]
library(reshape)
dist.melt <-
  melt( distance , id.vars="Herb" )

## Finding closest five stations for eac herbarium point
library(dplyr); library(data.table); library(lubridate)

close.five <-
  dist.melt %>%
  group_by(Herb) %>%
  top_n(n = 5, wt = 1/value) 

arrange(close.five, Herbs, var)

