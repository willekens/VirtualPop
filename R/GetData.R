#' Reads data from the HMD and HFD
#' 
#' Reads data from the HMD and HFD
#' 
#' 
#' @param country country
#' @param user Name of the user, used at registration with the HMD and HFD. It
#' is assumed that the same name is used for both HMD and HFD.
#' @param pw_HMD Password to access HMD, provided at registration
#' @param pw_HFD Password to access HFD, provided at registration
#' @return \item{data_raw}{11 objects: country,reference year,life tables
#' females,life tables males,life tables sexes combined, fertility
#' table,fertility rates,asfrVV,tfr,population by age and sex (from HMD),female
#' population (from HFD): exposures}
#' @author Frans Willekens
#' @examples
#' 
#' 
#' ## Not Run
#' ## data_raw <- GetData (country,user,pw_HMD,pw_HFD)
#' ## End Not Run
#' 
#' 
#' @export GetData
GetData <- function(country,user,pw_HMD,pw_HFD)
{
# ==============  Part A Extract data from HMD and HFD  ==================
requireNamespace("HMDHFDplus")

# help function to list the available countries
countries <- HMDHFDplus::getHMDcountries()

# ====================  Get data from HMD and HFD: data_raw  =================
#country <- "USA"
refyear_data <- "all"
dataLH <- NULL
rates <- NULL
# =============  Read life tables and get death rates  ============
print (paste ("Extract data from HMD and HFD for ",country,sep=""))
df <- HMDHFDplus::readHMDweb(CNTRY=country,item="fltper_1x1",username=user,password=pw_HMD,fixup=TRUE)
dm <- HMDHFDplus::readHMDweb(CNTRY=country,item="mltper_1x1",username=user,password=pw_HMD,fixup=TRUE)
db <- HMDHFDplus::readHMDweb(CNTRY=country,item="bltper_1x1",username=user,password=pw_HMD,fixup=TRUE) 

# ============  Read conditional age-specific fertility rates ===============
# Read fertility table
fertTable <- HMDHFDplus::readHFDweb(CNTRY=country,item="pft",username=user,password=pw_HFD,fixup=TRUE)
attr(fertTable, "data") <- paste ("HFD",country,sep=" ")

# Read age-specific fertility rates
asfrVV <- HMDHFDplus::readHFDweb(CNTRY=country,item="asfrVV",username=user,password=pw_HFD,fixup=TRUE)
# Read TFR (period)
tfrRR <- HMDHFDplus::readHFDweb(CNTRY=country,item="tfrRR",username=user,password=pw_HFD,fixup=TRUE)
fert_rates <- HMDHFDplus::readHFDweb(CNTRY=country,item="mi",username=user,password=pw_HFD,fixup=TRUE)

# ======  Part B Extract population from HMD and female population exposure by parity from HFD ====
#  Population from  HMD  
dpopHMD <- HMDHFDplus::readHMDweb(CNTRY=country,item="Population",username=user,password=pw_HMD,fixup=TRUE) 
#  Population from HFD: Exposure in conditional fertility rates 
dpopHFD <- HMDHFDplus::readHFDweb(CNTRY=country,item="exposRRpa",username=user,password=pw_HFD,fixup=TRUE)

data_raw <- list (country=country,refyear=refyear_data,LTf=df,LTm=dm,LTcom=db,
fertTable=fertTable,fert_rates=fert_rates,asfrVV=asfrVV,tfrRR=tfrRR,dpopHMD=dpopHMD,dpopHFD=dpopHFD)

return  (data_raw)
}
