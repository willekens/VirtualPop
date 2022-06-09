#' Computes comulative hazard at duration t.
#' 
#' Computes cumulative hazard at duration t from age-specific demographic
#' rates.
#' 
#' 
#' @param t Duration at which cumulative hazard is required.
#' @param breakpoints Breakpoints: values of x at which piecewise-constant
#' rates change.
#' @param rates Piecewise-constant rates
#' @return Cumulative hazard at duration t
#' @author Frans Willekens
#' @seealso Function H_pw called by pw_root, which is called by r_pw_exp.
#' @examples
#' 
#' 
#' ## Not Run
#' ## data(rates)
#' ## H_wp(t, breakpoints, rates) 
#' ## End Not Run
#' 
#' 
#' @export H_pw
H_pw <-
function (t, breakpoints, rates) 
{
    lent <- length(t)
    cumhaz <- vector(mode = "numeric", length = lent)
    for (i in 1:lent) {
        int <- findInterval(t[i], breakpoints, all.inside = TRUE)
        z <- t[i] - breakpoints[1:int]
        exposure <- c(-diff(z), z[int])
        kk <- rates[1:int] * exposure
        cumhaz[i] <- sum(kk)
    }
    return(cumhaz)
}
