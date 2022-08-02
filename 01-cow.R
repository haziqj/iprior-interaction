# devtools::install_github("haziqj/iprior")
library(iprior)
library(tidyverse)

data(cattle, package = "jmcm")
names(cattle) <- c("id", "time", "group", "weight")
cattle$id <- as.factor(cattle$id)  # convert to factors
# levels(cattle$group) <- c("Treatment A", "Treatment B")
str(cattle)
write_csv(cattle, file = "cattle.csv")

# Model 1: {}
mod1 <- iprior(weight ~ time, cattle, kernel = "fbm,0.5",
               est.hurst = TRUE, control = list(restarts = 4))

# Model 2: {X}
mod2 <- iprior(weight ~ group * time, cattle, kernel = "fbm,0.5",
               est.hurst = TRUE, control = list(restarts = 4))

# Model 3: {C}
mod3 <- iprior(weight ~ id * time, cattle, kernel = "fbm,0.5",
               est.hurst = TRUE, control = list(restarts = 4))

# Model 4: {C,X}
mod4 <- iprior(weight ~ group * time +  id * time, cattle, kernel = "fbm,0.5",
               est.hurst = TRUE, control = list(restarts = 4))

# Model 5: {CX}
mod5 <- iprior(weight ~ id * group * time, cattle, kernel = "fbm,0.5", 
               est.hurst = TRUE, control = list(restarts = 4))

# Results table
cow_table <- function(mod) {
  form <- capture.output(mod$ipriorKernel$formula)
  form <- substring(form, 10)
  tibble(formula = form, loglik = logLik(mod), error = get_prederror(mod),
         no_lambda = length(coef(mod)) - 1,
         hurst = get_hurst(mod))
}
tab <- rbind(
  cow_table(mod1), cow_table(mod2), cow_table(mod3),
  cow_table(mod4), cow_table(mod5)
)
cbind(model = 1:5, tab) %>% kbl(format = "rst", digits = 2)

# # Plot of fitted regression lines
# plot_fitted_multilevel(mod5, show.legend = FALSE, cred.bands = FALSE) +
#   labs(x = "Time", y = "Weight")