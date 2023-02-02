## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
#  install.packages ("VirtualPop")

## ---- eval=FALSE--------------------------------------------------------------
#  devtools::install_github("willekens/VirtualPop")

## ---- eval=FALSE--------------------------------------------------------------
#  install.packages("devtools")

## -----------------------------------------------------------------------------
library (VirtualPop)

## ----eval=FALSE---------------------------------------------------------------
#  utils::vignette (package="VirtualPop")

## ----eval=FALSE---------------------------------------------------------------
#  utils::vignette (topic="Tutorial",package="VirtualPop")

## ----eval=FALSE---------------------------------------------------------------
#  # install.packages ("HMDHFDplus")
#  library (HMDHFDplus)
#  countries <- HMDHFDplus::getHMDcountries()

## ----eval=FALSE---------------------------------------------------------------
#  user <- "your email address"
#  pw_HMD <- "password for HMD"
#  pw_HFD <- "password for HFD"

## ----eval=FALSE---------------------------------------------------------------
#  data_raw <- GetData (country="USA",user,pw_HMD,pw_HFD)

## ----eval=FALSE---------------------------------------------------------------
#  country <- "USA"
#  df <- HMDHFDplus::readHMDweb(CNTRY=country,item="fltper_1x1",username=user,password=pw_HMD,fixup=TRUE)
#  dm <- HMDHFDplus::readHMDweb(CNTRY=country,item="mltper_1x1",username=user,password=pw_HMD,fixup=TRUE)
#  fert_rates <- HMDHFDplus::readHFDweb(CNTRY=country,item="mi",username=user,password=pw_HFD,fixup=TRUE)
#  dpopHMD <- HMDHFDplus::readHMDweb(CNTRY=country,item="Population",username=user,password=pw_HMD,fixup=TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  yearsHMD <- unique(df$Year)
#  yearsHFD <- unique(fert_rates$Year)

## ----eval=FALSE---------------------------------------------------------------
#  dm <- read.table(paste(path,"mltper_1x1.txt",sep=""))
#  df <- read.table(paste(path,"fltper_1x1.txt",sep=""))
#  fert_rates <- read.table(paste(path,"USAmi.txt",sep=""))

## ----eval=FALSE---------------------------------------------------------------
#  data_raw <- list (country=country,LTf=df,LTm=dm,fert_rates=fert_rates,dpopHMD=dpopHMD)
#  attr(data_raw,"country") <- country

## ----eval=FALSE---------------------------------------------------------------
#  save (data_raw,file=paste(path,"data_raw",country,".RData",sep=""))

## ----eval=FALSE---------------------------------------------------------------
#  rates <- VirtualPop::GetRates (data=data_raw,refyear=2019)

## -----------------------------------------------------------------------------
library (VirtualPop)
rates <- NULL
utils::data(rates)

## -----------------------------------------------------------------------------
dataLH <- VirtualPop::GetGenerations (rates,ncohort=1000,ngen=4) 

## -----------------------------------------------------------------------------
utils::data(dataLH)

## ----eval=FALSE---------------------------------------------------------------
#  save (dataLH,file=paste(path,"dataLH",country,".RData",sep=""))

## ---- eval=FALSE--------------------------------------------------------------
#  load(file=paste(path,"dataLH",country,".RData",sep=""))

## -----------------------------------------------------------------------------
ncohort <- 1000
dLH_nomort <- VirtualPop::GetGenerations (rates,ncohort=ncohort,ngen=4,iage=85)

## ----eval=FALSE---------------------------------------------------------------
#  dpopus <- dpopHMD[dpopHMD$Year==2019,c("Female1","Male1")]
#  dimnames(dpopus) <- list (Age=0:110,Sex=c("Females","Males"))

## -----------------------------------------------------------------------------
utils::data(dpopus)

## ---- results="hide"----------------------------------------------------------
data(dpopus)
z <- dpopus[16:nrow(dpopus),]
age_end_perc <- apply(z,2,function(x) x/sum(x))

## ---- eval=FALSE--------------------------------------------------------------
#  xx <- VirtualPop::GetGenerations (rates,ncohort=1000,ngen=1,age_end_perc =age_end_perc)
#  # Age distribution of the virtual population at censoring time
#  n <- table (trunc(xx$x_D),xx$sex)
#  nperc <- apply(n,2,function(x) x/sum(x))
#  age_end_perc <- NULL

## ---- eval=FALSE--------------------------------------------------------------
#  library(foreign)
#  path <- "" # or different path
#  foreign::write.dta(dataLH, paste (path,"dataLH.dta",sep=""))

## ---- eval=FALSE--------------------------------------------------------------
#  foreign::write.foreign(dataLH,
#          paste (path,"dataLH.txt",sep=""),
#          paste (path,"dataLH.sps",sep=""), package="SPSS")

## -----------------------------------------------------------------------------
format(lubridate::date_decimal(2019.409), "%Y-%m-%d")

## ----eval=FALSE,warning=FALSE,message=FALSE-----------------------------------
#  country <- "JPN"
#  refyear2 <- c(1998,2010,2020)
#  ncohort <- 1000
#  dLH_Japan <-  NULL
#  df <- HMDHFDplus::readHMDweb(CNTRY=country,item="fltper_1x1",username=user,password=pw_HMD,fixup=TRUE)
#  dm <- HMDHFDplus::readHMDweb(CNTRY=country,item="mltper_1x1",username=user,password=pw_HMD,fixup=TRUE)
#  fert_rates <- HMDHFDplus::readHFDweb(CNTRY=country,item="mi",username=user,password=pw_HFD,fixup=TRUE)
#  data_raw <- list (country=country,LTf=df,LTm=dm,fert_rates=fert_rates)
#  attr(data_raw,"country") <- country
#  for (iy in 1:3)
#  {  rates <- VirtualPop::GetRates (data=data_raw,refyear=refyear2[iy])
#     dJapan <- VirtualPop::GetGenerations (rates,ncohort=ncohort,ngen=4)
#     if (iy >1) ID1 <- dLH_Japan + 1
#     dLH_Japan <-  rbind (dLH_Japan,dJapan)
#  }

## ---- eval=FALSE--------------------------------------------------------------
#  z <- addmargins (table (dLH_Japan$sex[dLH_Japan$gen==1],trunc(dLH_Japan$bdated)[dLH_Japan$gen==1]))
#  z

## ---- eval=FALSE--------------------------------------------------------------
#  # Children
#  sum(dLH_Japan$nch[dLH_Japan$gen==1 & dLH_Japan$sex=="Female"]
#  # Grandchildren
#  sum(dLH_Japan$nch[dLH_Japan$gen==2 & dLH_Japan$sex=="Female"])
#  # Great-grandchildren
#  sum(dLH_Japan$nch[dLH_Japan$gen==3 & dLH_Japan$sex=="Female"])

