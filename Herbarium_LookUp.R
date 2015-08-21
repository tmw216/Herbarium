##############################################################
############  Herbarium Flowering Lookup Coding   ############
##                Date:  August 21, 2015                    ##
##                Using tmw computer                        ##
##############################################################
##############################################################

## Clear memory
rm(list=ls())

## Read in data 
sanbi<-read.csv("sanbi.csv", header=TRUE, na.string=".")
pellie<-read.csv("pellie.csv", header=TRUE, na.string=".")

###################################
####### PELLIE WORKSHEET  #########
###################################
## List column names
colnames(pellie)

## Search $Habitat or $Locality
pellie.flower<-pellie[grep("flower|mauve|pink|cream|yellow|cream|rose|rosy|olive|carmine|green|fl|white|purple|red|pale|salmon|purplish|crimson|brown|magenta|black|scarlet|flor|violet|chocolate|maroon|orange|grey|petals|markings",pellie$Habitat),]

## List row numbers in data set (pellie rwnum = 3181)
pellie$rownum <- 1:nrow(pellie)

## Search for key words throughout dataset
pellie.fl <- pellie[grep("flower|mauve|pink|cream|yellow|cream|rose|rosy|olive|carmine|green|fl|white|purple|red|pale|salmon|purplish|crimson|brown|magenta|black|scarlet|flor|violet|chocolate|maroon|orange|grey|petals|markings",pellie$Habitat),]
str(pellie.fl)

pellie.fl$rownum<-as.factor(pellie.fl$rownum)
levels(pellie.fl$rownum)

## Search for rows not containing floral characteristics, export into txt, then tranfer mannually to xls
pellie.notfl <- pellie[!pellie$rownum %in% pellie.fl$rownum,]

## Export data into new csv file
library(xlsx)
write.table(x = pellie.notfl, "pellienotfl.txt", sep="\t")
write.table(x = pellie.flower, "pellie.flower.txt", sep="\t")

## Count occurences/frequency
require(plyr)
p = count(pellie.flower, "Scientific.Name")
write.table(x = p, "p.txt", sep="\t")

###################################
####### SANBI WORKSHEET  ##########
###################################

#### Search $Notes
sanbi.flower<-sanbi[grep("flower|mauve|pink|cream|yellow|cream|rose|rosy|olive|carmine|green|fl|white|purple|red|pale|salmon|purplish|crimson|brown|magenta|black|scarlet|flor|violet|chocolate|maroon|orange|grey|petals|markings",sanbi$NOTES),]

## List row numbers in data set (sanbi rwnum = 13651)
sanbi$rownum <- 1:nrow(sanbi)

## Search for key words throughout dataset
sanbi.fl <- sanbi[grep("flower|mauve|pink|cream|yellow|cream|rose|rosy|olive|carmine|green|fl|white|purple|red|pale|salmon|purplish|crimson|brown|magenta|black|scarlet|flor|violet|chocolate|maroon|orange|grey|petals|markings",sanbi$NOTES),]
str(sanbi.fl)

sanbi.fl$rownum<-as.factor(sanbi.fl$rownum)
levels(sanbi.fl$rownum)

## Search for rows not containing floral characteristics
sanbi.notfl <- sanbi[!sanbi$rownum %in% sanbi.fl$rownum,]

## Export data into new csv file
write.table(x = sanbi.notfl, "sanbi.notfl.txt", sep="\t")
write.table(x = sanbi.flower, "sanbi.flower.txt", sep="\t")

## Count occurences/frequency
san = count(sanbi.flower, "TAXNAME")
write.table(x = san, "san.count.txt", sep="\t")

## Final merged file == HerbFinal.csv
