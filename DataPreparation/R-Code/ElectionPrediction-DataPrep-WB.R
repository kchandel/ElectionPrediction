

# R code to extract and prepare data for West Bengal from 
# 1. Candidates data from election commission site
# 2. Religion ( distribution of hindu and muslim population) from Census 2011
# 3. Literacy and Sex Ratio from Census ( extracted from MapsOfIndia website)
# 4. Party incumbency effect from 2004 election winners

library(data.table)
library(data.table)
library(dplyr)
library(sqldf)
library(stringdist)
library(reshape2)
library(RCurl)
library(XML)
library(data.table)

setwd( "C:/Users/user/Documents/GL-Classes/7/grp-assignment")


# Load EC Data for 2009 
EC_2009_Cand<-read.csv("GE_2009_Candidates.csv", header=T)

# Filter out blank rows form the dataset 
EC_2009_Cand <- filter(EC_2009_Cand,PC.name!='')
str(EC_2009_Cand)
View(EC_2009_Cand)


#Extract unique constituencies 
EC.Const.2009 <- as.data.frame(unique(EC_2009_Cand$PC.name))

#Extract unique states
EC.State.2009 <- as.data.frame(unique(EC_2009_Cand$State.name))

#####  Merge EC 2009 data with Religion data downloaded from Census 2011 #######

# EC data for MH
EC.Cand.2009.WB <- filter(EC_2009_Cand,ST_CODE=='S25')
EC.Const.WB.2009 <- unique(EC.Cand.2009.WB$PC.name)
EC.Const.WB.2009 <- as.data.frame(EC.Const.WB.2009)
EC.Const.WB.2009 <- plyr::rename(EC.Const.WB.2009, c(EC.Const.WB.2009="Constituency"))
View(EC.Const.WB.2009)
write.csv(EC.Const.WB.2009,"EC.CONST.WB.2009.csv")


# Load MP religion data from 2011 census
# source :http://www.censusindia.gov.in/2011census/C-01.html

WB_Religion <-read.csv("WB_Religion.csv", header=T)
View(WB_Religion)

# Match the constituencies in EC data with the district in Religion data 

#distance.methods<-c('lv','dl','jaccard','jw')
distance.methods<-c('jw')
dist.methods<-list()

for(m in 1:length(distance.methods))
{
  dist.name.enh<-matrix(NA, ncol = length(WB_Religion$Area.Name),nrow = length(EC.Const.WB.2009$Constituency))
  for(i in 1:length(WB_Religion$Area.Name)) {
    for(j in 1:length(EC.Const.WB.2009$Constituency)) { 
      dist.name.enh[j,i]<-stringdist(tolower(WB_Religion[i,]$Area.Name),tolower(EC.Const.WB.2009[j,]),method = distance.methods[m])      
      #adist.enhance(UP_Crime[i,]$name,EC.Dist[j,]$name)
    }  
  }
  dist.methods[[distance.methods[m]]]<-dist.name.enh
}

match.s1.s2.enh<-NULL
for(m in 1:length(dist.methods))
{
  dist.matrix.1<-as.matrix(dist.methods[[distance.methods[m]]])
  min.name.enh<-apply(dist.matrix.1, 1, base::min)
  for(i in 1:nrow(dist.matrix.1))
  {
    s2.i<-match(min.name.enh[i],dist.matrix.1[i,])
    s1.i<-i
    #Changed by Kapil 
    match.s1.s2.enh<-rbind(data.frame(s2.i=s2.i,s1.i=s1.i,s2name=WB_Religion[s2.i,]$Area.Name, s1name=EC.Const.WB.2009[s1.i,], adist=min.name.enh[i],method=distance.methods[m]),match.s1.s2.enh)
  }
}

matched.names.matrix.1<-dcast(match.s1.s2.enh,s2.i+s1.i+s2name+s1name~method, value.var = "adist")
View(matched.names.matrix.1)

write.csv(matched.names.matrix.1,"matched.name.matrix.WB.csv")


# Loading the matched constituency and district file 
matched.dist<-read.csv("WB-ReligionDistrict-Const-Matching.csv", header=T)
WB_Religion$WB_Religion_District <- WB_Religion$Area.Name

# Merge MP_Religion with matched.dist
WB_Religion <- merge(WB_Religion,matched.dist,by=c("WB_Religion_District"), all=TRUE)

WB_Religion <- plyr::rename(WB_Religion, c(WB_Constituency="PC.name"))
#Now merge UP_
EC.Cand.2009.WB.Final <-merge(EC.Cand.2009.WB,WB_Religion,by=c("PC.name"), all=TRUE)

# Select the requied rows and colums only 
EC.Cand.2009.WB.Final <- subset(EC.Cand.2009.WB.Final, select=c(1,3,8:18,24,25,26))
EC.Cand.2009.WB.Final<-EC.Cand.2009.WB.Final[1:368,]
write.csv(EC.Cand.2009.WB.Final,"EC_Religion_Matched_WB.csv")



#####  Merge above dataset with Literacy and Sex ratio data  #######

#Extract the literacy data for MH districts 

urlWB<-"http://www.mapsofindia.com/maps/westbengal/westbengal-district.htm"

#Our table is the 12th table
LiteracyData_WB<-readHTMLTable(urlWB,which=12)
write.csv(LiteracyData_WB,"LiteracyData_WB.csv")
View(LiteracyData_WB)


# do a string match for district of MH Literacy data and constituency from EC data 

distance.methods<-c('jw')
dist.methods<-list()

for(m in 1:length(distance.methods))
{
  dist.name.enh<-matrix(NA, ncol = length(LiteracyData_WB$District),nrow = length(EC.Const.WB.2009$Constituency))
  for(i in 1:length(LiteracyData_WB$District)) {
    for(j in 1:length(EC.Const.WB.2009$Constituency)) { 
      dist.name.enh[j,i]<-stringdist(tolower(LiteracyData_WB[i,]$District),tolower(EC.Const.WB.2009[j,]),method = distance.methods[m])      
      #adist.enhance(UP_Crime[i,]$name,EC.Dist[j,]$name)
    }  
  }
  dist.methods[[distance.methods[m]]]<-dist.name.enh
}

match.s1.s2.enh<-NULL
for(m in 1:length(dist.methods))
{
  dist.matrix.1<-as.matrix(dist.methods[[distance.methods[m]]])
  min.name.enh<-apply(dist.matrix.1, 1, base::min)
  for(i in 1:nrow(dist.matrix.1))
  {
    s2.i<-match(min.name.enh[i],dist.matrix.1[i,])
    s1.i<-i
    #Changed by Kapil 
    match.s1.s2.enh<-rbind(data.frame(s2.i=s2.i,s1.i=s1.i,s2name=LiteracyData_WB[s2.i,]$District, s1name=EC.Const.WB.2009[s1.i,], adist=min.name.enh[i],method=distance.methods[m]),match.s1.s2.enh)
  }
}

matched.names.matrix.1<-dcast(match.s1.s2.enh,s2.i+s1.i+s2name+s1name~method, value.var = "adist")
View(matched.names.matrix.1)

write.csv(matched.names.matrix.1,"matched.Literacy.matrix.WB.csv")


# Loading the matched constituency and district wise Literacy file
matched.dist<-read.csv("WB-LiteracyDistrict-Const-Matching.csv", header=T)
LiteracyData_WB$WB_Literacy <- LiteracyData_WB$District

# Merge MP_Literacy with matched.dist
LiteracyData_WB <- merge(LiteracyData_WB,matched.dist,by=c("WB_Literacy"), all=TRUE)

LiteracyData_WB <- plyr::rename(LiteracyData_WB, c(WB_Constituency="PC.name"))
#Now merge with EC data 
EC.Cand.2009.WB.Final2 <-merge(EC.Cand.2009.WB.Final,LiteracyData_WB,by=c("PC.name"), all=TRUE)

# Select the requied rows and colums only 
EC.Cand.2009.WB.Final3 <- subset(EC.Cand.2009.WB.Final2, select=-c(17:21))
EC.Cand.2009.WB.Final3 <-EC.Cand.2009.WB.Final3[1:368,]

write.csv(EC.Cand.2009.WB.Final3,"EC.Final.WB.2009.csv")



#####  Merge above dataset with incumbency effect from 2004 Lok Sabha election #######

## Add data for incumbency effect  MH

EC.2004.WB.Winners <- read.csv("GE_2004_Winners_WB.csv", header=T)


# do a string match for Constituency in 2004 and 2009 data
distance.methods<-c('jw')
dist.methods<-list()

for(m in 1:length(distance.methods))
{
  dist.name.enh<-matrix(NA, ncol = length(EC.2004.WB.Winners$PC_NAME),nrow = length(EC.Const.WB.2009$Constituency))
  for(i in 1:length(EC.2004.WB.Winners$PC_NAME)) {
    for(j in 1:length(EC.Const.WB.2009$Constituency)) { 
      dist.name.enh[j,i]<-stringdist(tolower(EC.2004.WB.Winners[i,]$PC_NAME),tolower(EC.Const.WB.2009[j,]),method = distance.methods[m])      
      #adist.enhance(UP_Crime[i,]$name,EC.Dist[j,]$name)
    }  
  }
  dist.methods[[distance.methods[m]]]<-dist.name.enh
}

match.s1.s2.enh<-NULL
for(m in 1:length(dist.methods))
{
  dist.matrix.1<-as.matrix(dist.methods[[distance.methods[m]]])
  min.name.enh<-apply(dist.matrix.1, 1, base::min)
  for(i in 1:nrow(dist.matrix.1))
  {
    s2.i<-match(min.name.enh[i],dist.matrix.1[i,])
    s1.i<-i
    #Changed by Kapil 
    match.s1.s2.enh<-rbind(data.frame(s2.i=s2.i,s1.i=s1.i,s2name=EC.2004.WB.Winners[s2.i,]$PC_NAME, s1name=EC.Const.WB.2009[s1.i,], adist=min.name.enh[i],method=distance.methods[m]),match.s1.s2.enh)
  }
}

matched.names.matrix.1<-dcast(match.s1.s2.enh,s2.i+s1.i+s2name+s1name~method, value.var = "adist")
View(matched.names.matrix.1)

write.csv(matched.names.matrix.1,"matched.2004and2009.matrix.WB.csv")

# Loading the matched constituency data for 2004 and 2009
matched.dist<-read.csv("matched.2004and2009.EC.WB.csv", header=T)
EC.2004.WB.Winners$EC_CONSTITUENCY_2004 <- EC.2004.WB.Winners$PC_NAME

# Merge UP_Religion with matched.dist
EC.2004.WB.Winners <- merge(EC.2004.WB.Winners,matched.dist,by=c("EC_CONSTITUENCY_2004"), all=TRUE)
EC.2004.WB.Winners <- filter(EC.2004.WB.Winners,EC_CONSTITUENCY_2009 != 'NA')

EC.2004.WB.Winners <- plyr::rename(EC.2004.WB.Winners, c(EC_CONSTITUENCY_2009="PC.name"))

EC.Cand.2009.WB.Final4 <-merge(EC.Cand.2009.WB.Final3,EC.2004.WB.Winners,by=c("PC.name"), all=TRUE)

# Select the requied rows and colums only 
EC.Cand.2009.WB.Final5 <- subset(EC.Cand.2009.WB.Final4, select=-c(19:21))

# Rename the column for incumbent party 
EC.Cand.2009.WB.Final5 <- plyr::rename(EC.Cand.2009.WB.Final5, c(PARTYABBRE="INCUMBENT_PARTY"))

# Final file with incumbency data 
write.csv(EC.Cand.2009.WB.Final5,"EC.Final.WB.2009.csv")




