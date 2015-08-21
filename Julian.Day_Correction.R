##############################################################
#############  Julian Date Correction Coding    ##############
##                Date:  August 21, 2015                    ##
##                Using tmw computer                        ##
##############################################################
##############################################################

## Clear memory
rm(list=ls())

## Read in data 
final<- read.csv(file="HerbFinal.csv", header=TRUE, na.string='.')
# Col = Julian.Day
# Change from  Jan 1 = 1 to July 1 = 0

library(date)
convert.jd <- function(jd, yr) {
  jd.length <- length(jd)
  stopifnot(jd.length == length(yr))
  ret.jd <- numeric(jd.length)
  ret.yr <- numeric(jd.length)
  jul.1 <- as.numeric(as.date("7/1/1960"))
  dec.31 <- as.numeric(as.date("12/31/1960"))
  for (i in 1:jd.length) {
    if (jd[i] >= jul.1) {
      ret.jd[i] <- jd[i] - jul.1
      ret.yr[i] <- yr[i] + 0.5
    } else {
      ret.jd[i] <- jd[i] + dec.31 - jul.1 + 1
      ret.yr[i] <- yr[i] - 0.5
    }
  }
  list(ret.jd=ret.jd, ret.yr=ret.yr)
}

# Save data in one single data frame (with two vectors)
julian <- convert.jd(final$Julian.Day, final$Year)

# Write vector to text file
write.csv(julian$ret.jd, file = "julday.csv")  # read by typing ->  ?write.table
write.csv(julian$ret.yr, file = "julyr.csv") 

## Checking dates
date.ddmmmyy(julian$ret.jd[364])  #23 July 1960

## Dates merged into == HerbFinal.csv
