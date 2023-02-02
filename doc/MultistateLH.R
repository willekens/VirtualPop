## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
A <- matrix(c(   0.0,0.10,0.05,        
                 0.07,0.0,0.03,
                 0.02,0.05,0.0),nrow=3,byrow=TRUE)
namstates <- c("A","B","C")
dimnames(A) <- list(origin=namstates,destination=namstates)
diag(A) <- -rowSums(A)
B <- -A
B

## -----------------------------------------------------------------------------
bio <- msm::sim.msm (qmatrix=-B,mintime=20,maxtime=40,start=1)
bio

## -----------------------------------------------------------------------------
library (VirtualPop)
rates <- NULL
data(rates)

## -----------------------------------------------------------------------------
rates$ratesM[26:29,,]

## -----------------------------------------------------------------------------
popsim <- data.frame (ID=3,
           born=1990.445,
           start=0,
           end=55,
           st_start="par0")
ch <- suppressWarnings(Sim_bio (datsim=popsim,ratesM=rates$ratesM))
ch

## -----------------------------------------------------------------------------
format(lubridate::date_decimal(1990.445+28.0567), "%Y-%m-%d")
format(lubridate::date_decimal(1990.445+34.789), "%Y-%m-%d")

## -----------------------------------------------------------------------------
Children (dat0=dataLH[c(1,3),1:11],rates)

## -----------------------------------------------------------------------------
library (VirtualPop)
rates <- NULL
data(rates)

## -----------------------------------------------------------------------------
refyear <- 2019
ages <- c(0:110)
ncohort <- 1000
ID <- 1:ncohort
sex <- rbinom(ncohort,1,prob=1/2.05)
sex <- factor (sex,levels=c(0,1),labels=c("Male","Female"),ordered=TRUE)
# Population size by sex
nmales <- length(sex[sex=="Male"])
nfemales <- length(sex[sex=="Female"])
gen <- rep(1,ncohort) # generation 1
# Decimal date of birth
bdated <- refyear+runif(ncohort)
# Create data frame
d <- data.frame (ID=ID,gen=gen,sex=sex,bdated=bdated,ddated=NA,x_D=NA,IDpartner=NA,IDmother=NA,IDfather=NA,jch=NA,nch=NA)
# Ages at death, obtained by sampling a peicewise-exponential distribution, using the rpexp function of the msm package
d$x_D[d$sex=="Male"] <- msm::rpexp(n=nmales,rate=rates$ASDR[,"Males"],t=ages)
d$x_D[d$sex=="Female"] <- msm::rpexp(n=nfemales,rate=rates$ASDR[,"Females"],t=ages)
# Decimal data of death
d$ddated <- d$bdated+d$x_D

## ----results="hide"-----------------------------------------------------------
d <- VirtualPop::Partnership(dLH=d)

## -----------------------------------------------------------------------------
head(d)

## ----warning=FALSE------------------------------------------------------------
dch1 <- VirtualPop::Children(dat0=d,rates=rates)

## -----------------------------------------------------------------------------
dch1$dch$IDfather <- dch1$data$IDpartner[dch1$dch$IDmother]

## -----------------------------------------------------------------------------
head(dch1$data)
head(dch1$dch)

## ----results="hide"-----------------------------------------------------------
d2 <- VirtualPop::Partnership (dLH=dch1$dch)

## ----warning=FALSE------------------------------------------------------------
dch2 <-  VirtualPop::Children(dat0=d2,rates=rates)

## ----results="hide"-----------------------------------------------------------
d3 <- VirtualPop::Partnership (dLH=dch2$dch)

## ----warning=FALSE------------------------------------------------------------
dch3 <-  VirtualPop::Children(dat0=d3,rates=rates)
d4 <- VirtualPop::Partnership (dLH=dch3$dch)
dch4 <-  VirtualPop::Children(dat0=d4,rates=rates)
d4 <- dch4$data[,1:which (colnames(dch4$data)=="nch")]

## -----------------------------------------------------------------------------
data4 <- rbind(dch1$data,dch2$data,dch3$data,dch4$data)

