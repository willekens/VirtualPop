#' Generates Individual Fertility Histories, Using Function Sim_bio.
#' 
#' Individual fertility histories
#' 
#' 
#' @param dat0 Data frame with base individual data on members of virtual
#' population
#' @param rates Mortality and fertility rates. The object 'rates' is produced
#' by Getrates_refyear.R
#' @return List object with two objects: (a) data frame with individual info
#' and fertility history of egos and (b) children data frame
#' @author Frans Willekens
#' @export Children
#' @examples
#' utils::data(dataLH)
#' utils::data(rates)
#' dat0 <- dataLH[1:10,]
#' out <- Children(dat0=dat0,rates=rates)
#'
Children <- function (dat0,rates)
{ 
# Generates individual fertility careers
# and produces data structure dch, which has record for each child 
# with date of birth, sex, date of death, age at death, and ID of mother (and father)
ncohort <- nrow(dat0)
nfemales <- length(dat0$sex[dat0$sex=="Female"])
nmales <- length(dat0$sex[dat0$sex=="Male"])
nch <- vector (mode="numeric",length=nrow(dat0))
#    MAX 9 children
age_ch <- matrix(NA,nrow=ncohort,ncol=9,dimnames=list(ID=dat0$ID,Parity=1:9))
#sex_ch <- matrix(NA,nrow=ncohort,ncol=9,dimnames=list(ID=dat0$ID,Parity=1:9))
ID_ch <- matrix(NA,nrow=ncohort,ncol=9,dimnames=list(ID=dat0$ID,Parity=1:9))
cmc_ch <- matrix(NA,nrow=ncohort,ncol=9,dimnames=list(ID=dat0$ID,Parity=1:9))
namsex <- c("Male","Female")

a <- Sys.time()
id <-  npreviousgen <- max(dat0$ID)
idseq <-  bdated <- idmother <-jch <- NULL
for (i in 1:ncohort)
 { if (dat0$sex[i]=="Male") next
   if (is.na(dat0$IDpartner[i])) next
    # Hierarchical: fertility career of a single female (uses msm::rpexp)
# 	ch <- Hierarchical (cASFR=ASFR,dat0$x_D[i])
  end = min(dat0$x_D[i],dat0$x_D[dat0$ID==dat0$IDpartner[i]])   # -0.75) # alive at conception
  popsim <- data.frame(ID=dat0$ID[i],born=dat0$bdated[i],start=0,end=end,st_start="par0")
   ch <- Sim_bio (datsim=popsim,ratesM=rates$ratesM) # see main_datar.R
   nch[i] <- ch$nstates-1
   ch$age_ch <- ch$ages_trans
#   nch[i] <- ch$nch
   if (nch[i]>0)
     { for (j in 1:nch[i])
       { age_ch[i,j] <- ch$age_ch[j]
       	 id <- id + 1
   	     ID_ch[i,j]  <- id
   	   #  sex_ch[i,j] <- ch$sex_ch[j]
   	    # cmc_ch[i,j] <- year_as_cmc(dat0$bdated[i]+age_ch[i,j])$cmc
       }
      # idseq <- c(idseq,ID_ch[i,1:nch[i]])
      # sexseq <- c(sexseq,sex_ch[i,1:nch[i]])
      bdated <- c(bdated,dat0$bdated[i]+age_ch[i,1:nch[i]])
      # ID of children
      idseq <- c(idseq,ID_ch[i,1:nch[i]])
      jch <-   c(jch,1:nch[i])
     } 
      # ID of mother
      idmother <- c(idmother,rep(dat0$ID[i],nch[i]))
    #  idfather <- c(idfather,rep(dat0$ID[dat0$IDpartner[i]],nch[i]))
   }
b <- Sys.time()
b-a
dat0$nch <- nch

table (nch[dat0$sex=="Female"])
perc <- table (nch[dat0$sex=="Female"])/sum(table (nch[dat0$sex=="Female"]))
sum(perc[2:6]) # 0.9137 Vergelijk met 0.9155 = sum(fertTable$b1x[fertTable$Year==1963],na.rm=TRUE)
sum(perc[3:6]) # 0.8163               0.8210 = sum(fertTable$b2x[fertTable$Year==1963],na.rm=TRUE)
sum(perc[4:6])  # 0.6118              0.6140
sum(perc[5:6])  # 0.4016              0.4021
sum(perc[6])    #  0.2880             O.6234  sum(fertTable$b5px[fertTable$Year==1963],na.rm=TRUE)


dati=cbind(dat0,id=ID_ch,age=age_ch)
#e <- which (colnames(dati)==1)
#colnames(dati)[e[1]:(e[1]+4)] <- paste("age_ch",1:5,sep="")
#colnames(dati)[e[2]:(e[2]+4)] <- paste("ID_ch",1:5,sep="")

nchTot <- sum(nch)
sex <- factor (rbinom(n=nchTot,size=1,prob=0.5)+1,levels=c(1,2),labels=c("Male","Female"))

# bdate <- format(lubridate::date_decimal(bdated), "%Y-%m-%d") 
igen <- dat0$gen[nrow(dat0)]
#In absence of children, dch <- NA
if (all(nch==0)) dch <- NA else
  { dch <- data.frame(ID=idseq,gen=igen+1,sex=sex,bdated=bdated,ddated=NA,x_D=NA,
             IDpartner=NA,IDmother=idmother,IDfather=NA,jch=jch)
                   #  IDgrand=NA,IDgreat=NA,nch=NA)

# dch <- Lifespan (data=dch,ASDR=ASDR)
# Replace Lifespan by the following lines of code
ages <- c(0:110)
z <- table(dch$sex)
nmales <- z[1]
nfemales <- z[2]
dch$ddated <- NA
dch$x_D <- NA
dch$x_D[dch$sex=="Male"] <- msm::rpexp(n=nmales,rate=rates$ASDR[,"Males"],t=ages)
dch$x_D[dch$sex=="Female"] <- msm::rpexp(n=nfemales,rate=rates$ASDR[,"Females"],t=ages)
# Date of death (calendar date)
dch$ddated <- dch$bdated+dch$x_D
 }

aa <- list (data=dati,
            #age_ch=age_ch,
            #ID_ch=ID_ch,
            dch = dch
)
         #   cmc_ch=cmc_ch,
         #   sexseq=unname(sexseq),
         #   bdated=bdated)
 return (aa)
}
