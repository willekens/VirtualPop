#' Retrieves Data from HMD and HFD for a Selected Country (All Years)
#' 
#' (a) Retrieves rates, the period life tables and the period fertility tables.
#' (b) Computes death rates by age and sex, and birth rates by age and birth
#' order.
#' 
#' The user needs to register as a new user before data can be downloaded. To
#' register with HMD, go to https://www.mortality.org. To register with HFD, go
#' to https://www.humanfertility.org/cgi-bin/main.php.
#' 
#' @param data data
#' @param refyear Reference year, which is the year of period data
#' @return \item{ASDR}{Age-specific death rates, by sex (for reference year or
#' all years)} \item{ASFR}{Age-specific birth rates by birth order (for
#' reference year or all years)} \item{e0}{REMOVE}
#' @note To access the HMD and HFD, the function used HMDHFDplus written by Tim
#' Riffe and other at the Max Planck Institute for Demographic Research,
#' Rostock, Germany
#' @author Frans Willekens
#' @examples
#' 
#' 
#' \dontrun{ratesR <- GetRates(data,refyear)}
#' 
#' 
#' @export GetRates
GetRates <- function(data,refyear)
{
yearmort <- unique(data$LTm$Year)
yearfert <- unique(data$fert_rates$Year)

country <- data$country
df <- data$LTf
dm <- data$LTm
db <- data$LTcom
fert_rates <- data$fert_rates

# ============  Mortality rates for all years  =============
yearmort <- unique(df$Year)
ages <- df$Age[dm$Year==refyear]
drates <- array(dim=c(length(ages),2,length(yearmort)),
    dimnames=list (Ages=ages,Sex=c("Males","Females"),Year=yearmort))
for (iy in 1:length(yearmort))
  {drates[,1,iy] <- dm$mx[dm$Year==yearmort[iy]]
   drates[,2,iy] <- df$mx[df$Year==yearmort[iy]]
  }


# ============  conditional age-specific fertility rates ===============
yearfert <- unique (fert_rates$Year)
ages12 <- fert_rates$Age[fert_rates$Year==refyear]
ages <- c(0:(min(ages12-1)),ages12)
dfrates <- array(dim=c(length(ages),5,length(yearfert)),
    dimnames=list (Ages=ages,Parity=paste("parity",1:5,sep=""),Year=yearfert))

for (iy in 1:length(yearfert))
  { ASFR0 <- subset(fert_rates[,-c(1,2,ncol(fert_rates))], fert_rates$Year==yearfert[iy])
    rownames(ASFR0)<- fert_rates$Age[fert_rates$Year==yearfert[iy]]
    minage_fert <- min(rownames(ASFR0))
    maxage_fert <- max(rownames(ASFR0))
    ASFR0[is.na(ASFR0)] <- "0"
    # Fertility rates is 0 for ages 0 to 11
    ASFR00 <- cbind (m1x=rep(0,12),m2x=rep(0,12),m3x=rep(0,12),m4x=rep(0,12),m5px=rep(0,12))
    rownames(ASFR00) <- 0:11
    # Non-zero fertility rates
    # zz <- transform(ASFR0,m1x = as.numeric(m1x),m2x=as.numeric(m2x),m3x=as.numeric(m3x),
    #                m4x=as.numeric(m4x),m5px=as.numeric(m5px))
    ASFR <-rbind (ASFR00,ASFR0)
    numASFR <- t(apply (ASFR,1,function(x) as.numeric(x)))
    dfrates[,,iy] <- numASFR
  }

ratesCountryAll <- list (ASDR=drates,ASFR=dfrates)
attr(ratesCountryAll,"country") <- country

# ===========  Get rates for reference year  ==========
irefyearmort <- which (dimnames(ratesCountryAll$ASDR)$Year==refyear)
irefyearfert <- which (dimnames(ratesCountryAll$ASFR)$Year==refyear)
rates <- list ()
rates$ASDR <- ratesCountryAll$ASDR[,,irefyearmort]
rates$ASFR <- ratesCountryAll$ASFR[,,irefyearfert]

# ============ Transition matrix for multistate modelling  ==========
nn <- 7
namstates <- c(paste("par",0:(nn-1),sep=""))
ratesM <- array(data=0,dim=c(56,nn,nn),dimnames=list(Age=0:55,Destination=namstates,Origin=namstates))
ratesM[,2,1] <- -rates$ASFR[,1]
ratesM[,3,2] <- -rates$ASFR[,2]
ratesM[,4,3] <- -rates$ASFR[,3]
ratesM[,5,4] <- -rates$ASFR[,4]
ratesM[,6,5] <- -rates$ASFR[,5]
ratesM[,7,6] <- -rates$ASFR[,5]
#ratesM[,8,7] <- -rates$ASFR[,5]
#ratesM[,9,8] <- -rates$ASFR[,5]

ratesM[,1,1] <- rates$ASFR[,1]
ratesM[,2,2] <- rates$ASFR[,2]
ratesM[,3,3] <- rates$ASFR[,3]
ratesM[,4,4] <- rates$ASFR[,4]
ratesM[,5,5] <- rates$ASFR[,5]
ratesM[,6,6] <- rates$ASFR[,5]
#ratesM[,7,7] <- rates$ASFR[,5]
#ratesM[,8,8] <- rates$ASFR[,5]
rates$ratesM <- ratesM

attr(rates,"country") <- country
attr(rates,"year") <- refyear


return (rates)
}
