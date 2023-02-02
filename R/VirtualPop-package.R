

#' dataLH data
#' 
#' simulated population of four generations
#' 
#' 
#' @name dataLH
#' @docType data
#' @format A data frame with data on 29954 individuals (10000 in initial cohort). \describe{
#'	\item{ID}{Identification number} 	
#'	\item{gen}{Generation}
#' 	\item{sex}{Sex. A factor with levels Males and Females}
#' 	\item{bdated}{Date of birth (decimal date} 
#'	\item{ddated}{Date of death (decimal date} 
#' 	\item{x_D}{Age at death (decimal number} 	
#'	\item{IDpartner}{ID of partner}
#' 	\item{IDmother}{ID of mother} 	
#'	\item{IDfather}{ID of father}
#' 	\item{jch}{Child's line number in the household}
#' 	\item{nch}{Number of children ever born}	
#'	\item{id.1}{ID of first child} 
#' 	\item{id.2}{ID of 2nd child}	
#'	\item{id.3}{ID of 3rd child} 
#' 	\item{id.4}{ID of 4th child}	
#'	\item{id.5}{ID of 5th child} 
#' 	\item{id.6}{ID of 6th child}	
#'	\item{id.7}{ID of 7th child} 
#' 	\item{id.8}{ID of 8th child}	
#'	\item{id.9}{ID of 9th child} 
#' 	\item{age.1}{Age of mother at birth of first child}
#' 	\item{age.2}{Age of mother at birth of 2nd child}
#' 	\item{age.3}{Age of mother at birth of 3rd child}
#' 	\item{age.4}{Age of mother at birth of 4th child}
#' 	\item{age.5}{Age of mother at birth of 5th child}
#' 	\item{age.6}{Age of mother at birth of 6th child}
#' 	\item{age.7}{Age of mother at birth of 7th child}
#' 	\item{age.8}{Age of mother at birth of 8th child}
#' 	\item{age.9}{Age of mother at birth of 9th child}}
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
#' \item{ASDR}{Mortality rates} 
#' \item{ASFR}{Fertility rates}
#' \item{ratesM}{Multistate transition rates} }
#' @source The data are downloaded from the Human Mortality Database (HMD) and
#' the Human Fertility Database (HFD). Country: USA. Year: 2019
#' @keywords datasets
NULL



#' dpopus data
#'  
#' Population of the United States in 2019 reported in the HMD (Population.txt file)
#'  
#' @name dpopus
#' @docType data
#' @format A data frame with 111 age groups (single years of age). \describe{
#' \item{Females}{Female population}
#' \item{Males}{Male population}}
#' @source The data are downloaded from the Human Mortality Database (HMD). Country: USA. Year: 2019
#' @keywords datasets
NULL

