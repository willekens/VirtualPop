\name{GetData}
\alias{GetData}
\title{Reads data from the HMD and HFD}
\usage{
GetData(country, user, pw_HMD, pw_HFD)
}
\arguments{
\item{country}{country}

\item{user}{Name of the user, used at registration with the HMD and HFD. It
is assumed that the same name is used for both HMD and HFD.}

\item{pw_HMD}{Password to access HMD, provided at registration}

\item{pw_HFD}{Password to access HFD, provided at registration}
}
\value{
\item{data_raw}{11 objects: country,reference year,life tables
females,life tables males,life tables sexes combined, fertility
table,fertility rates,asfrVV,tfr,population by age and sex (from HMD),female
population (from HFD): exposures}
}
\description{
Reads data from the HMD and HFD
}
\examples{

## Not Run
## data_raw <- GetData (country,user,pw_HMD,pw_HFD)
## End Not Run

}
\author{
Frans Willekens
}
