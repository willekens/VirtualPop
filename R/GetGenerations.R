#' Creates Database 'dataLH' from Mortality Rates and Fertility Rates
#' 
#' Creates database 'dataLH' from mortality rates by age and sex, and fertility
#' rates by age of mother and birth order
#' 
#' age_end_prec or iages are used to simulate ages at censoring. For instance,
#' to compare the virtual population with a real population for which
#' information is collected retorspectively in a cross-sectional survey, the
#' simulation window must be equal to the observation window. In other words,
#' the virtual population and the real population must have the same censoring.
#' 
#' @param rates List object with death rates (ASDR) and birth rates (ASFR)
#' @param ncohort Size of hypothetical birth cohort
#' @param ngen Number of generations to be simulated
#' @param age_end_perc If age_end_perc is not missing (NULL), then the
#' simulated ages at death are replaced by the age distribution given by
#' age_end_perc. The age distribution is a matrix with 2 dolumns, one for
#' females (column 1) and one for males (column 2). The distribution is given
#' by single years of age.
#' @param iages If iages is not missing, the vector of simulated ages at death
#' is replaced by the vector of individual ages at censoring
#' @param ID1 Identification number of first person in virtual population being
#' created (optional)
#' @return \item{dataLH}{The database of simulated individual lifespans and
#' fertility histories. The object 'dataLH' has two attributes: (a) the
#' calendar year of period rates and (b) the country}
#' @author Frans Willekens
#' @examples
#' 
#' 
#' # The object rates is produced by the function GetRates.
#' utils::data(rates)
#' dLH <- GetGenerations (rates=rates,ncohort=100,ngen=4)
#' 
#' 
#' @export GetGenerations
GetGenerations <- function (rates,ncohort,ngen,age_end_perc=NULL,iages=NULL,ID1=NULL)
{
 # If age_end is NOT NULL, x_D is replaced by age at survey (end of observation)
# utils::globalVariables (c("datag","refyear","m1x","m2x","m3x","m4x","m5px"))
# utils::globalVariables (c("datag","refyear","country"))

refyear <- attr(rates,"year")

# First generation
generation <- 1

#   Margolis 2019  50,000 agents in each race group 
country <- attr(rates,"country")
# ID
if (is.null(ID1)) ID <- 1:ncohort  else ID <-  ID1:(ID1+ncohort)

# ---------    sex   --------------
sex <- rbinom(ncohort,1,prob=1/2.05)
sex <- factor (sex,levels=c(0,1),labels=c("Male","Female"),ordered=TRUE)
nmales <- unname(table (sex)[1])
nfemales <- unname(table (sex)[2])
# ----------  Date of birth in reference year (F) and refyear-2 (M) -------------
data <- data.frame(ID=ID,
                   gen=rep(1,ncohort),
                   sex=sex,
                   bdated=NA,
                   ddated=NA,
                   x_D=NA,
 #                  start=NA,
 #                  end=NA,
                   IDpartner=NA,
                   IDmother=NA,
                   IDfather=NA,
                   jch=NA) 
                #   IDgrand=NA,
                #    IDgreat=NA)
# Males are 2 years older than females
data$bdated[data$sex=="Male"] <- refyear+runif(nmales)  # -2
data$bdated[data$sex=="Female"] <- refyear+runif(nfemales)

# data$bdate <- as.numeric(as.Date(d))  

# ========= simulate length of life using age-specific death rates  =========
#                       date of death and age at death
data <- Lifespan (data,ASDR=rates$ASDR)
# Without mortality
# rates$ASDR[,2] <- 0 # data$x_D[data$sex=="Female"] <- 80
# p <- Plot_cumhaz_uniroot(rat=rates$ASDR[,1],u=0.1726) # u= surv prob; gives age 91.33

# Replace x_D with age at survey
if (!is.null(age_end_perc))
{ages <- as.numeric(dimnames(age_end_perc)[[1]])
age_censoring_m <- sample (ages,nmales,prob=age_end_perc[,2],replace=TRUE)+runif(nmales)
age_censoring_f <- sample (ages,nfemales,prob=age_end_perc[,1],replace=TRUE)+runif(nfemales)
data$x_D[data$gen==1 & data$sex=="Male"] <- age_censoring_m
data$x_D[data$gen==1 & data$sex=="Female"] <- age_censoring_f
}

if (!is.null(iages))
{ data$x_D[data$gen==1 & data$sex=="Female"] <- iages
}
test <- 31
if (test==1)
{
# ======  Ages at death: replaces Lifespan.r  =============
ages <- c(0:110)
data$x_D[data$sex=="Male"] <-
            msm::rpexp(n=nmales,rate=rates$ASDR[,"Males"],t=ages)
data$x_D[data$sex=="Female"] <-
           msm::rpexp(n=nfemales,rate=rates$ASDR[,"Females"],t=ages)
data$ddated <- data$bdated+data$x_D
}
# ------------  Mean lifetime in virtual pop  ---------------
e0 <-  aggregate(x=data$x_D,by=list(age=data$sex),mean)

# =====  First generation: simulate fertility careers (children)  ========
# Create object with life histories of children of initial pop

# popsim: input for Sim_bio.r
popsim <- data.frame (ID=3,
           born=1990.445,
           start=0,
           end=80,  # upper limit is age 30 CHECK compare with EDSD_GLHS_1.R
           st_start="par0")

#z <- rates$ (datsim=popsim,rates$ratesM)
#z  # Go to Children.r

#datg1 <- Children (dat0=data1,ASDR=rates$ASDR,ASFR=rates$ASFR)
data1 <- data
data2 <- Partnership (dLH=data1)
datg1 <- Children (dat0=data2,rates)
if (ngen>=2)
{
datg1$dch <- Partnership (dLH=datg1$dch)
datg2<- Children (dat0=datg1$dch,rates=rates)
}
if (ngen>=3)
{datg2$dch <- Partnership (dLH=datg2$dch)
datg3<- Children (dat0=datg2$dch,rates=rates)
}
if (ngen>=4)
{datg3$dch <- Partnership (dLH=datg3$dch)
datg4<- Children (dat0=datg3$dch,rates=rates)
}

if (ngen==1) {dataLH <- datg1$data}
if (ngen==2) {dataLH <- rbind(datg1$data,datg2$data)}
if (ngen==3) {dataLH <- rbind(datg1$data,datg2$data,datg3$data)}
if (ngen==4) {dataLH <- rbind(datg1$data,datg2$data,datg3$data,datg4$data)}

attr(dataLH,"country") <- country
attr(dataLH,"year") <- refyear

return(dataLH)
}
