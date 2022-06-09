## ----out.width = '80%'--------------------------------------------------------
knitr::include_graphics("table1.png")

## ----echo=FALSE---------------------------------------------------------------
# ===============  Number of children ever born  CPS June 2018    Women, by age   =================
# https://www.census.gov/data/tables/2018/demo/fertility/women-fertility.html#par_list_57
#   table t1.xlsx
nfemCPS <- c(10294,10607,11476,10889,10727, 9896,12524 )
# round (100 *nfemCPS/sum(nfemCPS),2)
#     44.2 percent have 0 children
# 15 to 50 years 
everBorn <- matrix (c(96.9,2.1,0.8,0.1,0,0.1,0,
  78.6,14,6,1,0.3,0.2,0,
  54.2,20.4,16.2,6.5,2.1,0.5,0.1,
  33.6,22.3,24.6,12.8,4.4,1.9,0.3,
  20.0,19.2,32.6,17.4,7.3,3.2,0.4,
  15,18.7,34.6,18.6,8.7,3.8,0.7,
  15.4,19.8,35.4,17.3,7.4,3.6,1.2),nrow=7,byrow=TRUE)
everBornTot <- c(44.2,16.8,21.7,10.7,4.3,1.9,0.4)

d <- rbind (everBorn,Allages=everBornTot)
d <- cbind (Females=c(nfemCPS,sum(nfemCPS)),d)
nbreaks <- c(15,20,25,30,35,40,45,50)
namagegroup <- vector(mode="character",length=7)
for (i in 1:6)
{ namagegroup[i] <- paste (nbreaks[i],"-",nbreaks[i+1]-1,sep="")
}
namagegroup[7] <- paste (nbreaks[i+1],"-",nbreaks[i+2],sep="")
dimnames(d) <- list (AgeGroup=c(namagegroup,"Total"),
           Number_of_children_ever_born_CPS=c("nfemales",0,1,2,3,4,"5-6","7-8"))
d

## -----------------------------------------------------------------------------
library (VirtualPop)
dataLH <- NULL
data(dataLH)
# load("/Users/frans/Documents/R/0 0 MAC/Simul_ABM/HMD_HFD+paper/R/dataUSA2019.RData") # !!!!!!!!!!!!!!
rates <- NULL
data(rates)
dataLH1 <- subset(dataLH,dataLH$gen==1 & dataLH$sex=="Female")

# Replace x_D by age distribution of women at CPS June 2018 (males 85)
nfemCPS <- c(10294,10607,11476,10889,10727, 9896,12524 )
perc <- nfemCPS/sum(nfemCPS)
nbreaks <- c(15,20,25,30,35,40,45,50)
nfemales0 <- length(dataLH1$ID[dataLH1$sex=="Female"])
# ages <- as.numeric(rownames(poprefyear_distrib))
dataLH1$x_D[dataLH1$sex=="Female"] <- sample (nbreaks[1:(length(nbreaks)-1)],nfemales0,prob=perc,replace=TRUE) + runif(nfemales0,min=0,max=5)
dataLH1$x_D[dataLH1$sex=="Male"] <- 85
# Adjust the calendar date of censoring
dataLH1$ddated <- dataLH1$bdated + dataLH1$x_D
dataLH1 <- dataLH1[,1:which (colnames(dataLH1)=="nch")]
dataLH1$nch <- NA

## -----------------------------------------------------------------------------
# Age distribution at censoring in the virtual population
age_interview_VirtualPopulation <- cut (dataLH1$x_D[dataLH$sex=="Female"],breaks=nbreaks,include.lowest=TRUE,labels=namagegroup)
nfem0 <- table (age_interview_VirtualPopulation)
round (100 * nfem0/sum(nfem0),2)

## ----echo=FALSE---------------------------------------------------------------
# Age distribution of respondents at survey date, CPS 2018
cat("age_CPS")
names(perc) <- names(nfem0)
round (100*perc,2)

## ----warning=FALSE------------------------------------------------------------
ech <- Children (dataLH1,rates)
dataLH2 <- ech$data
dataLH1 <- dataLH2

## -----------------------------------------------------------------------------
# Select ages of mothers at childbirth from dataLH1 and convert ages to age groups
namages <- c("x_D","age.1","age.2","age.3","age.4","age.5","age.6","age.7","age.8","age.9")
ww <- subset (dataLH1[,c(6,21:29)],dataLH1$sex=="Female")
# names <- c("0-19","20-24","25-29","30-34","35-39","40+")
ww2 <- cut (data.matrix(ww),breaks=nbreaks,include.lowest=TRUE,labels=namagegroup)
ww3 <- matrix(ww2,ncol=10)
colnames(ww3) <- namages

# For each age group at censoring, compute number of children born, by birth order (object nch),
# the number of children ever born ( object nchever),
# and the probability distribution of numbers of children ever born, by age group at censoring (vaiable ncheverPerc)
nch <- nchever <- ncheverPerc <- matrix (nrow=7,ncol=12)
for (i in 1:7)
{ zz <- subset (ww3,ww3[,1]==namagegroup[i])
  nch[i,c(1,4:ncol(nch))] <- apply(zz,2,function(x) length(x[!is.na(x)]))
  nchever[i,4:ncol(nchever)]  <-  - c(diff(nch[i,4:ncol(nchever)]),0)                                                  
}    
nch[,2] <- rowSums(nch[,4:ncol(nch)])
dimnames(nch) <- list (AgeGroup=c(namagegroup),
           nch=c("nfemales","nch",0:9))
nchever[,1:2] <- nch[,1:2]
nchever[,3] <- nchever[,1] - rowSums(nchever[,4:ncol(nch)])
dimnames(nchever) <- dimnames(nch)
ntab <- addmargins (nchever,margin=1)
ncheverPerc <- ntab
ncheverPerc[,3:ncol(nchever)] <- round (100*proportions (ntab[,3:ncol(nchever)],margin=1),1)
names(dimnames(ncheverPerc))[2] <- "Number_of_children_ever_born_VirtualPopulation"

## -----------------------------------------------------------------------------
ncheverPerc

