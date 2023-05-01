source("00-common.R")

## ---- load_cow_data --------
data(cattle, package = "jmcm")
names(cattle) <- c("id", "time", "group", "weight")
cattle$id <- as.factor(cattle$id)  # convert to factors
# levels(cattle$group) <- c("Treatment A", "Treatment B")
# str(cattle)
# write_csv(cattle, file = "cattle.csv")
N <- nrow(cattle)

## ---- plot_cow_data --------
ggplot(cattle, aes(time, weight, group = id, col = group)) +
  geom_line() +
  labs(x = "Time (days)", y = "Weight (kg)", col = "Treatment\ngroup") +
  scale_x_continuous(breaks = unique(cattle$time)) +
  scale_colour_manual(values = my_cols[c(1, 3)])
  
## ---- est_cow_data --------
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
  mod4 <- iprior(weight ~ (group +  id) * time, cattle, kernel = kernel,
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
  
  bind_cols(
    model = 1:5,
    bind_rows(
      cow_table(mod1)[1, ],
      cow_table(mod2)[1, ],
      cow_table(mod3)[1, ],
      cow_table(mod4)[1, ],
      cow_table(mod5)[1, ]
    )
  )
}

# Hurst = 0.5
res1 <- est_all(kernel = "fbm,0.5", est.hurst = FALSE)
res1 <- res1 %>%
  mutate(
    k = c(2, 3, 3, 4, 4),
    AIC = 2 * k - 2 * loglik,
    BIC = k * log(N) -2 * loglik 
  )

# Hurst = 0.3
res2 <- est_all(kernel = "fbm,0.3", est.hurst = FALSE)
res2 <- res2 %>%
  mutate(
    k = c(2, 3, 3, 4, 4),
    AIC = 2 * k - 2 * loglik,
    BIC = k * log(N) -2 * loglik 
  )

# Estimate hurst
res3 <- est_all(kernel = "fbm", est.hurst = TRUE)
res3 <- res3 %>%
  mutate(
    k = c(3, 4, 4, 5, 5),
    AIC = 2 * k - 2 * loglik,
    BIC = k * log(N) -2 * loglik 
  )

save(res1, res2, res3, file = "cowres.RData")


# kbl(res2[c(1,3,5,7,9),], format = "rst", digits = 3)
