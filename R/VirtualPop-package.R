

#' dataLH data
#' 
#' simulated population of four generations
#' 
#' 
#' @name dataLH
#' @docType data
#' @format A data frame with data on 1000 individuals. \describe{
#' \item{code(ID)}{Identification number} 
#` \item{code(gen)}{Generation}
#' \item{code(sex)}{Sex. A factor with levels \code{Males} \code{Females}}
#' \item{code(bdated)}{Date of birth (decimal date)}
#' \item{code(ddated)}{Date of death (decimal date)} 
#` \item{code(x_D)}{Age at death (decimal number)} 
#` \item{code(IDpartner)}{ID of partner}
#' \item{code(IDmother)}{ID of mother} 
#` \item{code(IDfather)}{ID of father}
#' \item{code(jch)}{Child's line number in the household}
#' \item{code(nch)}{Number of children ever born} 
#` \item{code(id.1)}{ID of first child} 
#` \item{code(id.2)}{ID of 2nd child} 
#` \item{code(id.3)}{ID of 3rd child} 
#` \item{code(id.4)}{ID of 4th child} 
#` \item{code(id.5)}{ID of 5th child} 
#` \item{code(id.6)}{ID of 6th child} 
#` \item{code(id.7)}{ID of 7th child} 
#` \item{code(id.8)}{ID of 8th child} 
#` \item{code(id.9)}{ID of 9th child} 
#` \item{code(age.1)}{Age of mother at birth of first child}
#' \item{code(age.2)}{Age of mother at birth of 2nd child}
#' \item{code(age.3)}{Age of mother at birth of 3rd child}
#' \item{code(age.4)}{Age of mother at birth of 4th child}
#' \item{code(age.5)}{Age of mother at birth of 5th child}
#' \item{code(age.6)}{Age of mother at birth of 6th child}
#' \item{code(age.7)}{Age of mother at birth of 7th child}
#' \item{code(age.8)}{Age of mother at birth of 8th child}
#' \item{code(age.9)}{Age of mother at birth of 9th child} }
#' @source Simulation uses period mortality rates and fertility rates by birth
#' order from the United States 2019. The data are downloaded from the Human
#' Mortality Database (HMD) and the Human Fertility Database (HFD).
#' @keywords datasets
NULL





#' rates data
#' 
#' Mortality rates by age and sex: fertility rates by age and birth order
#' 
#' @name rates
#' @docType data
#' @format A list of three objects. \describe{
#' \item{code(ASDR)}{Mortality rates} 
#` \item{code(ASFR)}{Fertility rates}
#' \item{code(ratesM)}{Multistate transition rates} }
#' @source The data are downloaded from the Human Mortality Database (HMD) and
#' the Human Fertility Database (HFD). Country: USA. Year: 2019
#' @keywords datasets
NULL

#` dpopusa data
#`  
#` Population of the United States in 2019 reported in the HMD (Population.txt file)
#`  
#` @name dpopusa
#' @docType data
#` format A data frame with 111 age groups (single years of age). \describe{
#` \item{code(Females)}{Female population}
#` \item{code(Males)}{Male population}
#' @source The data are downloaded from the Human Mortality Database (HMD). Country: USA. Year: 2019
#' @keywords datasets
NULL

