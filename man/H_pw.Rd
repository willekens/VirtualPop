\name{H_pw}
\alias{H_pw}
\title{Computes comulative hazard at duration t.}
\usage{
H_pw(t, breakpoints, rates)
}
\arguments{
\item{t}{Duration at which cumulative hazard is required.}

\item{breakpoints}{Breakpoints: values of x at which piecewise-constant
rates change.}

\item{rates}{Piecewise-constant rates}
}
\value{
Cumulative hazard at duration t
}
\description{
Computes cumulative hazard at duration t from age-specific demographic
rates.
}
\examples{

## Not Run
## data(rates)
## H_wp(t, breakpoints, rates) 
## End Not Run

}
\seealso{
Function H_pw called by pw_root, which is called by r_pw_exp.
}
\author{
Frans Willekens
}
