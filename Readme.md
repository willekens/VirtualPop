<!-- badges: start --> [![CRAN
status](https://www.r-pkg.org/badges/version/VirtualPop)](https://CRAN.R-project.org/package=VirtualPop)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/willekens/VirtualPop/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/willekens/VirtualPop/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

*V**i**r**t**u**a**l**P**o**p* generates a virtual population from
demographic data. The demographic data are death rates (mortality rates)
by age and sex, and birth rates (fertility rates) by age and birth order
(parity). The current version of VirtualPop uses rates downloaded from
the Human Mortality Database (HMD) and the Human Fertility Database
(HFD).

*V**i**r**t**u**a**l**P**o**p* simulates, for each member of a virtual
population, the lifespan and the fertility history. Simulation is in
continuous time. The simulation model is an individual-level state
transition (multi-state) model. Simulated life histories are stored in a
data structure commonly used for sample surveys. The data structure is a
data frame (flat file) with one record per individual. Personal
attributes are represented as column variables. If requested,
*V**i**r**t**u**a**l**P**o**p* generates a multi-generation virtual
population by simulating life (fertility) histories of children,
grandchildren, and great-grandchildren. The genealogies facilitate the
study of family ties and kinship networks implicit in a set of
demographic rates.

The package comes with four vignettes.

-   VirtualPop: Simulation of individual fertility careers from
    age-specific fertility and mortality rates. A tutorial. A good place
    to start.
-   Sampling piecewise-exponential waiting time distributions. The
    theory underlying the sampling of ages at death and ages at
    childbirth.
-   Simulation of life histories. The theory underlying the generation
    of life histories using multistate models.
-   Validation of the simulation. Results of the simulation are compared
    with demographic (kinship) indicators computed from census and
    survey data. The virtual population generated from demographic rates
    of the United States in 2019 is compared with observations in the
    Current Population Survey 2018.

The companion package *F**a**m**i**l**i**e**s* extract family
relationships from the multi-generation virtual population. These
relationships are the basis for the computation of kinship indicators.
Areas of application include kinship networks, the demography of
grandparenthood, the demography of sandwich generations (double burden
of child care and parental care), and perspectives of children on
population.

You should be able to install VirtualPop using the following R code:

        library(devtools)
        devtools::install_github("willekens/VirtualPop")
