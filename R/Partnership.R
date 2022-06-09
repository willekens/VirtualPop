#' Allocates Partners to Members of Virtual Population.
#' 
#' Randomly allocates partners to egos
#' 
#' 
#' @param dataLH Database
#' @return Updated version of dataLH, which includes the IDs of partners.
#' @author Frans Willekens
#' @examples
#' 
#' 
#' ## Not run
#' data(dataLH)
#' Partnership(dataLH)
#' ## End (Not run) 
#' 
#' 
#' @export Partnership
Partnership <- function (dataLH)
{
nf <- length(dataLH$ID[dataLH$sex=="Female" & is.na(dataLH$IDpartner)])
nm <- length(dataLH$ID[dataLH$sex=="Male" & is.na(dataLH$IDpartner)])
# Number of females  may exceed number of males
nsample <- min(nf,nm)
if (nsample < nf)
{id <- sample(dataLH$ID[dataLH$sex=="Female" & is.na(dataLH$IDpartner)],nsample,replace=FALSE)
 dataLH$IDpartner[dataLH$sex=="Male" & is.na(dataLH$IDpartner)] <- id 
 xx <- subset (dataLH$ID,dataLH$sex=="Male" & !is.na(dataLH$IDpartner))
 partners <- cbind (female=id,male=xx)
} else
{id <- sample(dataLH$ID[dataLH$sex=="Male" & is.na(dataLH$IDpartner)],nsample,replace=FALSE)
 dataLH$IDpartner[dataLH$sex=="Female" & is.na(dataLH$IDpartner)] <- id 
 xx <- subset (dataLH$ID,dataLH$sex=="Female" & !is.na(dataLH$IDpartner))
 partners <- cbind (male=id,female=xx)}
for (i in 1:nrow(partners))
{ dataLH$IDpartner[dataLH$ID==partners[i,1]] <-partners[i,2]
}
return(dataLH)
}
