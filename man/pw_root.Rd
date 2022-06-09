\name{pw_root}
\alias{pw_root}
\title{Equation for which root must be determined.}
\usage{
pw_root(t, breakpoints, rates, uu)
}
\arguments{
\item{t}{Vector of durations to be considered in determining root.}

\item{breakpoints}{Breakpoints}

\item{rates}{Piecewise-constant rates}

\item{uu}{Random draw from standard uniform distribution.}
}
\value{
Vector of differences between cumulative hazard and -log(uu) for
different values of t.
}
\description{
Equation: cumulative hazard functionn + log(uu) = 0
}
\details{
The function is called by function uniroot (base R), which is called by
r.pw_exp
}
\examples{
## Not run
}
\seealso{
Functions H_wp and r.pw_exp
}
\author{
Frans Willekens
}
