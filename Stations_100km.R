##############################################################
##############  Find Stations <100km Coding     ##############
##                Date:  August 21, 2015                    ##
##                Using protea computer                     ##
##############################################################
##############################################################

## Clear memory
rm(list=ls())

## Load in data sets 
load("../obs/20100831_StationData/20100831_ObservedStationData.Rdata") # loading final obs and station data sets
station = station  # 2621 obs of 9 var 'lat/lon'
obs = obs   # 22634312 obs of 5 var NO 'lat/lon'
herb <- read.csv(file="../HerbFinal.csv", header=TRUE, na.string='.')    # Herb + Schulze -- 750 obs of 26 var
melt <- read.csv(file = "../melt.csv", header = TRUE, na.string = '.')

library(dplyr); library(data.table); library(lubridate) 

# Change value from char to numeric
melt$value = as.numeric(melt$value)
str(melt)

close.five <-
  Unique.Final %>%
  group_by(Herb.Pts, var) %>%
  top_n(n = 5, wt = 1/Distance) %>%
  arrange(close.five, Herbs, var)

close <- select(close.five, Herbs, Stats, Distance, var)

close1 <- arrange(close, Herbs, var)  ## mean ppt/tmin/tmax across all weather stations at a given herb point (across all time)

weather.sts.mean <- 
  close.five %>% 
  group_by(Herb.Pts, var) %>%
  summarise( mean_weather = mean(mean_value))

## Final merged file == Unique_Final.csv
