\name{Lifespan}
\alias{Lifespan}
\title{Generates Individual Lifespan(s)}
\usage{
Lifespan(data, ASDR)
}
\arguments{
\item{data}{Data frame with individual data}

\item{ASDR}{Age-specific death rates}
}
\value{
data: data frame 'dataLH' with date of death and age of death
completed.
}
\description{
Simulate length of life using age-specific death rates.Generate date of
death and age at death. The function uses the rpexp function from the
package msm and uniroot of base R
}
\examples{

data(dataLH)
data(rates)
z = Lifespan (dataLH,ASDR=rates$ASDR)

}
\author{
Frans Willekens
}
