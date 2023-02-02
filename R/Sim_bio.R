#' Generic Function to Generate Single Life History
#' 
#' The function is called from the function Children. It uses the rpexp
#' function of the msm package.
#' 
#' 
#' @param datsim Data frame with individual data
#' @param ratesM Multistate transition rates in standard (multistate) format
#' @return \item{age_startSim}{Age at start of simulation}
#' \item{age_endSim}{Age at end of simulation} \item{nstates}{Number of states}
#' \item{path}{path: sequence of states occupied} \item{ages_trans}{Ages at
#' transition}
#' @author Frans Willekens
#' @examples
#' 
#'   # Generates single fertility history from mortality rates by age 
#'   # and fertility rates by age and parity
#'   # Fertily history is simulated from starting age to ending age
#'   # Individual starts in state "par0"
#'   # ratesM is an object with the rates in the proper format for multistate analysis
#'   utils::data(rates)
#'   popsim <- data.frame(ID=1,born=2000.450,start=0,end=80,st_start="par0")
#'   ch <- Sim_bio (datsim=popsim,ratesM=rates$ratesM) 
#' 
#' @export Sim_bio
Sim_bio <- function (datsim, ratesM) 
{
    nsample <- nrow(datsim)
    ID <- datsim$ID
    age_startRate <- as.numeric(dimnames(ratesM)[[1]][1])
    age_endRate <- max(as.numeric(dimnames(ratesM)[[1]]))
    age_startSim <- floor(datsim$start)
    if (floor(datsim$end) == datsim$end) 
        datsim$end <- datsim$end + 0.0001
    if (datsim$end > age_endRate) 
        datsim$end <- age_endRate + 0.99000000000000021
    age_endSim <- floor(datsim$end)
    numstates <- dim(ratesM)[2]
    namstates <- unlist(unname(dimnames(ratesM)[3]))
    if (is.factor(datsim$st_start)) 
        st_start <- as.numeric(datsim$st_start)  else 
                 st_start <- as.numeric(factor(datsim$st_start, levels = namstates,ordered = TRUE))
    max.ntrans <- 30
    ntrans <- 0
    cur_age <- age_startSim
    rem_ages <- cur_age:age_endSim
    rem_ages_index <- which(age_startSim:age_endSim %in% ceiling(cur_age):age_endSim)
    cur_st <- st_start
    ntrans_max <- 30
    ages_seq <- states_seq <- vector(mode = "numeric", length = ntrans_max)
    ages_seq[1] <- 0
    states_seq[1] <- st_start
    ntrans <- 1
    while (cur_age < ceiling(datsim$end)) {
        rate <- ratesM[rem_ages_index, cur_st, cur_st]
        if (length(rate) != length(rem_ages - cur_age)) 
            warning (paste("length(rate)=", length(rate), "cur_age=", 
                cur_age, "maxage=", ceiling(datsim$end), "rem_ages=", 
                rem_ages))
        nextlag <- suppressWarnings(msm::rpexp(1, rate, rem_ages - cur_age))
        if (is.na(nextlag) | cur_age + nextlag > ceiling(datsim$end)) 
            break
        cur_age <- cur_age + nextlag
        rem_ages_index <- which(age_startSim:age_endSim %in% 
            floor(cur_age):age_endSim)
        if (length(rem_ages_index) == 1) 
            rem_ages <- cur_age
        else rem_ages <- c(cur_age, ceiling(cur_age):floor(datsim$end))
        ntrans <- ntrans + 1
        if (ntrans > ntrans_max) {
            warning (paste("Number of transitions exceeds maximum. ntrans_max=", 
                ntrans_max, sep = ""))
        }
        ages_seq[ntrans] <- cur_age
        cur_age_index <- ceiling(cur_age)
        cur_q <- ratesM[cur_age_index, , ]
        des_st_possible <- (1:numstates)[-cur_st]
        if (cur_q[cur_st, cur_st] == 0) 
            break
        prob = cur_q[-cur_st, cur_st]/(-cur_q[cur_st, cur_st])
        cur_st <- ifelse(length(des_st_possible) == 1, des_st_possible, 
            sample(des_st_possible, size = 1, prob = prob))
        states_seq[ntrans] <- cur_st
    }
    path <- paste(namstates[states_seq], collapse = "")
    states_seq <- states_seq[states_seq > 0]
    aa <- list(age_startSim = age_startSim, age_endSim = floor(datsim$end) + 
        1, nstates = ntrans, states = states_seq, path = path, 
        ages_trans = ages_seq[2:ntrans])
    return(aa)
}
