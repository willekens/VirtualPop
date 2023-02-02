#' Equation for which root must be determined.
#' 
#' Equation: cumulative hazard functionn + log(uu) = 0
#' 
#' The function is called by function uniroot (base R), which is called by
#' r.pw_exp
#' 
#' @param t Vector of durations to be considered in determining root.
#' @param breakpoints Breakpoints
#' @param rates Piecewise-constant rates
#' @param uu Random draw from standard uniform distribution.
#' @return Vector of differences between cumulative hazard and -log(uu) for
#' different values of t.
#' @author Frans Willekens
#' @seealso Functions H_pw and r.pw_exp
#' @examples
#' breakpoints <- c(0, 10, 20, 30, 60)
#' rates <- c(0.01,0.02,0.04,0.15)
#' z <- pw_root (t= c(10,18.3,23.6,54.7),breakpoints,rates,uu=0.43)
#' 
#' @export pw_root
pw_root <-
function (t, breakpoints, rates, uu) 
{
    aa <- H_pw(t, breakpoints, rates) + log(uu)
    return(aa)
}
