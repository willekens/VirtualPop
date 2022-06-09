## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
rexp(n=10,rate=0.1)

## -----------------------------------------------------------------------------
Rate_pw <- function (t,breakpoints,rates)
{ int <- findInterval(t,breakpoints,all.inside=TRUE)
  z <- rates[int]
  sojournInt <- t-breakpoints[int]
  h <- data.frame(t=t,rate=z,interval=int,startInt=breakpoints[int],sojourn=sojournInt)
  return(h)
}

## -----------------------------------------------------------------------------
breakpoints <- c(0, 10, 20, 30, 60)
rates <- c(0.01,0.02,0.04,0.15)
Rate_pw(t=18.3,breakpoints,rates)

## -----------------------------------------------------------------------------
Rate_pw(t=c(10,18.3,23.6,54.7),breakpoints,rates)  

## -----------------------------------------------------------------------------
VirtualPop::H_pw(t=c(10,18.3,23.6,54.7),breakpoints,rates)  

## ----fig1, fig.height = 5, fig.width = 5,fig.align = "center"-----------------
t <- 0:40
H <- VirtualPop::H_pw(t=t,breakpoints,rates) 
plot(t, H, type="l", lwd=3, col=2,xlab="Time",ylab="Cumulative hazard",las=1)
title(main="Figure 1. Cumulative hazard")
yy <- -log(1-0.35)
z <- which.min(abs(H-yy))
arrows (x0=c(0,t[z]),y0=c(yy,yy),x1=c(t[z],t[z]),y1=c(yy,0),angle=15,lty=1)
text(x=0.4,y=yy+0.05,labels=as.character (round(yy,4)))
text(x=t[z]+1.4,y=0,labels="23.27")


## ----fig2, fig.height = 5, fig.width = 5,fig.align = "center"-----------------
x <- t
plot(x, exp(-H), type="l",lwd=3,las=1,xlab="Duration",ylab="Survival probability",ylim=c(0,1))
title (main="Figure 2. Survival function")
yy <- 0.65
z <- which.min(abs(exp(-H)-yy))
arrows (x0=c(0,x[z]),y0=c(yy,yy),x1=c(x[z],x[z]),y1=c(yy,0),angle=15)
text(x=0.4,y=yy+0.03,labels=as.character (round(yy,2)))
text(x=x[z]+1.5,y=0,labels=x[z])

## -----------------------------------------------------------------------------
pw_root <- function(t, breakpoints,rates, uu){
    aa <- VirtualPop::H_pw(t, breakpoints,rates) + log(uu)
    # Cum hazard rate should be equal to - log(u), with u a value of survival function
    return(aa)
}
pw_root (t= c(10,18.3,23.6,54.7),breakpoints,rates,uu=0.43)

## -----------------------------------------------------------------------------
interval=c(breakpoints[1],breakpoints[length(breakpoints)])
uniroot(f=pw_root,interval=interval,breakpoints,rates,uu=0.65)

## -----------------------------------------------------------------------------
pw_sample <- VirtualPop::r.pw_exp (n=1000, breakpoints, rates=rates)

## -----------------------------------------------------------------------------
msm::qpexp((1-0.65),rates,breakpoints[-length(breakpoints)])

## -----------------------------------------------------------------------------
pw.sample.msm <- msm::rpexp (n=100,
                rate=rates,
                t=breakpoints[-length(breakpoints)])
mean(pw.sample.msm)
sd(pw.sample.msm)

## -----------------------------------------------------------------------------
rates <- NULL
library(VirtualPop)
data(rates)
z <- rownames(rates$ASDR)
ages <- as.numeric(z)
breakpoints <- c(ages,120)
ratesm <- rates$ASDR[,1]
ratesf <- rates$ASDR[,2]
nsample <- 2000 # sample size
d <- data.frame(sex=sample(x=c(1,2),size=nsample,replace=TRUE,prob=c(0.5,0.5)))
d$sex <-factor(d$sex,levels=c(1,2),labels=c("Male","Female"))
nmales <- length(d$sex[d$sex=="Male"])
nfemales <- length(d$sex[d$sex=="Female"])
d$x_D <- NA
d$x_D[d$sex=="Male"] <- VirtualPop::r.pw_exp (n=nmales, breakpoints, rates=ratesm)
d$x_D[d$sex=="Female"] <- VirtualPop::r.pw_exp (n=nfemales, breakpoints, rates=ratesf)
head(d)

## ----fig3, fig.height = 5, fig.width = 7.2,fig.align = "center"---------------
require (ggplot2)
p <- ggplot ()
p <- p + geom_density(data=d,aes(round (x_D,0),fill=sex,color=sex),alpha=0.3)  
p <- p + ggtitle ("Figure 3. Simulated ages at death, United States, 2019") +
    theme(legend.title = element_text(colour="black", size=10,face="bold")) +
    theme(legend.text = element_text(colour="blue", size=10,face="plain"))
p <- p + xlab("Age")+ylab("Density")
p <- p + theme (legend.position=c(0.15,0.88))
p <- p + scale_x_continuous (breaks=seq(0,110,by=10))
p

