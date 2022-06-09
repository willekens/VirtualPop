\name{Children}
\alias{Children}
\title{Generates Individual Fertility Histories, Using Function Sim_bio.}
\usage{
Children(dat0, rates)
}
\arguments{
\item{dat0}{Data frame with base individual data on members of virtual
population}

\item{rates}{Mortality and fertility rates. The object 'rates' is produced
by Getrates_refyear.R}
}
\value{
List object with two objects: (a) data frame with individual info
and fertility history of egos and (b) children data frame
}
\description{
Individual fertility histories
}
\author{
Frans Willekens
}
