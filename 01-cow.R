# devtools::install_github("haziqj/iprior")
library(iprior)
library(tidyverse)
library(kableExtra)

data(cattle, package = "jmcm")
names(cattle) <- c("id", "time", "group", "weight")
cattle$id <- as.factor(cattle$id)  # convert to factors
# levels(cattle$group) <- c("Treatment A", "Treatment B")
str(cattle)
write_csv(cattle, file = "cattle.csv")

est_all <- function(kernel = "fbm,0.5", est.hurst = FALSE) {
  
  # Model 1: {}
  mod1 <- iprior(weight ~ time, cattle, kernel = kernel,
                 est.hurst = est.hurst, control = list(restarts = 0))
  
  # Model 2: {X}
  mod2 <- iprior(weight ~ group * time, cattle, kernel = kernel,
                 est.hurst = est.hurst, control = list(restarts = 0))
  
  # Model 3: {C}
  mod3 <- iprior(weight ~ id * time, cattle, kernel = kernel,
                 est.hurst = est.hurst, control = list(restarts = 0))
  
  # Model 4: {C,X}
  mod4 <- iprior(weight ~ group * time +  id * time, cattle, kernel = kernel,
                 est.hurst = est.hurst, control = list(restarts = 0))
  
  # Model 5: {CX}
  mod5 <- iprior(weight ~ group * id * time, cattle, kernel = kernel, 
                 est.hurst = est.hurst, control = list(restarts = 0))
  
  
  # Results table
  cow_table <- function(mod) {
    form <- capture.output(mod$ipriorKernel$formula)
    form <- substring(form, 10)
    tibble(formula = form, loglik = logLik(mod), error = get_prederror(mod),
           lambda = paste0(round(get_lambda(mod), 3), collapse = ","),
           psi = iprior::dec_plac(get_psi(mod), 5),
           hurst = get_hurst(mod))
  }
  tab <- rbind(
    cow_table(mod1), cow_table(mod2), cow_table(mod3),
    cow_table(mod4), cow_table(mod5)
  )
  return(cbind(model = 1:5, tab))
}

# Hurst = 0.5
res1 <- est_all(kernel = "fbm,0.5", est.hurst = FALSE)

# Hurst = 0.3
res2 <- est_all(kernel = "fbm,0.3", est.hurst = FALSE)

# Estimate hurst
res3 <- est_all(kernel = "fbm", est.hurst = TRUE)



kbl(res2[c(1,3,5,7,9),], format = "rst", digits = 3)
