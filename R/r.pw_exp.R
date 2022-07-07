#' Sample from a piecewise-constant exponential distribution.
#' 
#' Takes n random draws from a piecewise-constant exponential distribution.
#' 
#' 
#' @param n Number of random draws required
#' @param breakpoints Breakpoints in piecewise-constant exponential
#' distribution
#' @param rates Piecewise-constant rates
#' @return Vector of waiting times, drawn from piecewise-exponential survival
#' function.
#' @author Frans Willekens
#' @examples
#' 
#' 
#' breakpoints <- c(0, 10, 20, 30, 60)
#' rates <- c(0.01,0.02,0.04,0.15)
#' pw_sample <- r.pw_exp (n=10, breakpoints, rates=rates)
#' 
#' 
#' @export r.pw_exp
r.pw_exp <-
function (n, breakpoints, rates) 
{
    success = TRUE
    if (!exists("pw_root")) 
        warning ("r.pw_exp: pw_root does not exist")
    if (!exists("H_pw")) 
        warning ("r.pw_exp: H_pw does not exist")
    i <- 1
    u <- runif(n)
    interval = c(breakpoints[1], breakpoints[length(breakpoints)])
    x_Dg <- vector(mode = "numeric", length = n)
    while (success == TRUE & i <= n) {
        xx <- tryCatch(uniroot(f = pw_root, interval = interval, 
            breakpoints, rates, uu = u[i])$root, error = function(e) z = 5000)
        if (xx == 5000) {
            success <- TRUE
            u[i] <- runif(1)
        }
        else {
            x_Dg[i] <- xx
            i = i + 1
        }
        x_Dg[i]
    }
    x_Dg
    return(x_Dg)
}
