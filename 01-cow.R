# devtools::install_github("haziqj/iprior")
library(iprior)
library(tidyverse)

data(cattle, package = "jmcm")
names(cattle) <- c("id", "time", "group", "weight")
cattle$id <- as.factor(cattle$id)  # convert to factors
# levels(cattle$group) <- c("Treatment A", "Treatment B")
str(cattle)
write_csv(cattle, file = "cattle.csv")

# Model 1: Null model
set.seed(456)
mod1 <- iprior(weight ~ time, cattle, kern = "fbm",
               control = list(restarts = 4))

# Model 2: weight ~ f(time) + f(treatment) + f(time dependent treatment)
set.seed(456)
mod2 <- iprior(weight ~ group * time, cattle, kernel = "fbm",
               method = "em", control = list(restarts = TRUE))

# Model 3: weight ~ f(time) + f(cow index) + f(time dependent cow index)
set.seed(456)
mod3 <- iprior(weight ~ id * time, cattle, kernel = "fbm",
               method = "mixed")

# Model 4: weight ~ f(time) + f(cow index) +  f(treatment)
#                   + f(time dependent cow index)
#                   + f(time dependent treatment)
set.seed(456)
mod4 <- iprior(weight ~ group * time +  id * time, cattle,
               kernel = "fbm", method = "mixed")

# Model 5: weight ~ f(time:cow:treatment)
set.seed(456)
mod5 <- iprior(weight ~ id * group * time, cattle, kernel = "fbm",
               method = "mixed")

# Results table
cow_table <- function(mod) {
  form <- capture.output(mod$ipriorKernel$formula)
  form <- substring(form, 10)
  tibble(formula = form, loglik = logLik(mod), error = get_prederror(mod),
         no_lambda = length(coef(mod)) - 1)
}
tab <- rbind(
  cow_table(mod1), cow_table(mod2), cow_table(mod3),
  cow_table(mod4), cow_table(mod5)
)
cbind(model = 1:5, tab)

# Plot of fitted regression lines
plot_fitted_multilevel(mod5, show.legend = FALSE, cred.bands = FALSE) +
  labs(x = "Time", y = "Weight")