\name{Partnership}
\alias{Partnership}
\title{Allocates Partners to Members of Virtual Population.}
\usage{
Partnership(dataLH)
}
\arguments{
\item{dataLH}{Database}
}
\value{
Updated version of dataLH, which includes the IDs of partners.
}
\description{
Randomly allocates partners to egos
}
\examples{

## Not run
data(dataLH)
Partnership(dataLH)
## End (Not run) 

}
\author{
Frans Willekens
}
