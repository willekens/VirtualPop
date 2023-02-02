#' Generates Individual Lifespan(s)
#' 
#' Simulate length of life using age-specific death rates.Generate date of
#' death and age at death. The function uses the rpexp function from the
#' package msm and uniroot of base R
#' 
#' 
#' @param data Data frame with individual data
#' @param ASDR Age-specific death rates
#' @return data: data frame 'dataLH' with date of death and age of death
#' completed.
#' @author Frans Willekens
#' @examples
#' 
#' 
#' utils::data(dataLH)
#' utils::data(rates)
#' z <- Lifespan (dataLH[1:5,],ASDR=rates$ASDR)
#' 
#' 
#' @export Lifespan
Lifespan <-
function (data, ASDR) 
{
    z <- table(data$sex)
    nmales <- z[1]
    nfemales <- z[2]
    data$ddated <- NA
    data$x_D <- NA
    ages <- c(0:110)
    data$x_D[data$sex == "Male"] <- msm::rpexp(n = nmales, rate = ASDR[, 
        "Males"], t = ages)
    data$x_D[data$sex == "Female"] <- msm::rpexp(n = nfemales, 
        rate = ASDR[, "Females"], t = ages)
    aggregate(data$x_D, by = list(data$sex), FUN = "mean")
    data$ddated <- data$bdated + data$x_D
    return(data)
}
