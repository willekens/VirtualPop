#' Allocates Partners to Members of Virtual Population.
#' 
#' Randomly allocates partners to egos
#' 
#' 
#' @param dLH Database
#' @return Updated version of database (dLH), which includes the IDs of partners.
#' @author Frans Willekens
#' @examples
#' 
#' 
#' utils::data(dataLH)
#' dLH=dataLH[1:10,]
#' # Remove current partner
#' dLH$IDpartner <- NA
#' d <- Partnership(dLH=dLH) 
#' # NOTE: partners are randomly selected from the individuals documented in dLH.
#' 
#' @export Partnership
Partnership <- function (dLH)
{
nf <- length(dLH$ID[dLH$sex=="Female" & is.na(dLH$IDpartner)])
nm <- length(dLH$ID[dLH$sex=="Male" & is.na(dLH$IDpartner)])
# Number of females  may exceed number of males
nsample <- min(nf,nm)
if (nsample < nf)
{id <- sample(dLH$ID[dLH$sex=="Female" & is.na(dLH$IDpartner)],nsample,replace=FALSE)
 dLH$IDpartner[dLH$sex=="Male" & is.na(dLH$IDpartner)] <- id 
 xx <- subset (dLH$ID,dLH$sex=="Male" & !is.na(dLH$IDpartner))
 partners <- cbind (female=id,male=xx)
} else
  {id <- sample(dLH$ID[dLH$sex=="Male" & is.na(dLH$IDpartner)],nsample,replace=FALSE)
   dLH$IDpartner[dLH$sex=="Female" & is.na(dLH$IDpartner)] <- id 
   xx <- subset (dLH$ID,dLH$sex=="Female" & !is.na(dLH$IDpartner))
   partners <- cbind (male=id,female=xx)
  }
for (i in 1:nrow(partners))
{ dLH$IDpartner[dLH$ID==partners[i,1]] <-partners[i,2]
}
return(dLH)
}
