library(glinternet)
library(glmnet)
library(tidyverse)
options(dplyr.summarise.inform = FALSE)
library(BAS)
library(doSNOW)
library(iprior)
theme_set(theme_classic())

## ---- read_model_code --------
# Read in the model codes and beta simulation values
model_codes <- readxl::read_excel("model_codes.xlsx") %>%
  mutate(code = paste0(x1, x2, x3, x1x2, x1x3, x2x3, x1x2x3, sep = ""))
beta_vals <- readxl::read_excel("model_codes.xlsx", sheet = "beta") %>%
  mutate(code = paste0(
    ifelse(x1 > 0, 1, 0),
    ifelse(x2 > 0, 1, 0),
    ifelse(x3 > 0, 1, 0),
    ifelse(x1x2 > 0, 1, 0),
    ifelse(x1x3 > 0, 1, 0),
    ifelse(x2x3 > 0, 1, 0),
    ifelse(x1x2x3 > 0, 1, 0),
    sep = "") %>% as.character()
  )

# > model_codes
# # A tibble: 19 × 8
# x1    x2    x3  x1x2  x1x3  x2x3 x1x2x3 code   
# <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <chr>  
#   1     1     0     0     0     0     0      0 1000000
#   2     0     1     0     0     0     0      0 0100000
#   3     0     0     1     0     0     0      0 0010000
#   4     1     1     0     1     0     0      0 1101000
#   5     1     1     0     0     0     0      0 1100000
#   6     1     0     1     0     1     0      0 1010100
#   7     1     0     1     0     0     0      0 1010000
#   8     0     1     1     0     0     1      0 0110010
#   9     0     1     1     0     0     0      0 0110000
#  10     1     1     1     1     1     1      1 1111111
#  11     1     1     1     1     1     1      0 1111110
#  12     1     1     1     1     1     0      0 1111100
#  13     1     1     1     1     0     1      0 1111010
#  14     1     1     1     0     1     1      0 1110110
#  15     1     1     1     1     0     0      0 1111000
#  16     1     1     1     0     1     0      0 1110100
#  17     1     1     1     0     0     1      0 1110010
#  18     1     1     1     0     0     0      0 1110000
#  19     0     0     0     0     0     0      0 0000000

## ---- sim_fn --------
# The simulation function
the_sim_fn <- function(nsim = 20, n = 200, corr = 0, err.sd = 1.5,
                       beta.true = c(1, 1, 1, 0.5, 0.5, 0.5, 0.25)) {
  
  no.cores <- parallel::detectCores() - 2
  pb <- txtProgressBar(min = 0, max = nsim, style = 3)
  progress <- function(i) setTxtProgressBar(pb, i)
  
  iprior_est_same_lambda <- function(formulaa = y ~ X1 + X2 + X3, dataa = dat) {
    mod <- kernL(formulaa, dataa, est.lengthscale = TRUE)
    # There is a bug in the BlockB function in kernL. Use est.lengthscale = TRUE
    # to bypass this (unnecessary) function, since we are doing direct
    # optimisation.
    iprior_loglik_fn <- function(theta = rnorm(2), modd = mod) {
      expand.theta <- mod$thetal$theta
      n.theta <- mod$thetal$n.theta
      expand.theta[-n.theta] <- theta[1]
      expand.theta[n.theta] <- theta[2]
      - 2 * logLik(modd, theta = expand.theta)
    }
    
    res <- NA
    for (k in 1:1) {
      optimres <- optim(rnorm(2), iprior_loglik_fn)
      res[k] <- optimres$value
    }
    
    c(res[which.min(res)], sd(res))
  }
  
  check_lasso <- function(beta) {
    main.eff <- beta[1:3]
    twoway.int <- beta[4:6]
    threeway.int <- beta[7]
    if (threeway.int > 0) {
      if (any(main.eff == 0)) return("invalid")
    }
    if (twoway.int[1] > 0) {
      if (main.eff[1] == 0 | main.eff[2] == 0) return("invalid")
    }
    if (twoway.int[2] > 0) {
      if (main.eff[1] == 0 | main.eff[3] == 0) return("invalid")
    }
    if (twoway.int[3] > 0) {
      if (main.eff[2] == 0 | main.eff[3] == 0) return("invalid")
    }
    return("valid")
  }
  
  combine_sim_res <- function(z) {
    final.res <- list()
    for (k in 1:6) {
      final.res[[k]] <- data.frame(do.call(rbind, lapply(z, function(x) x[[k]])))
    }
    names(final.res) <- names(z[[1]])
    c(lapply(final.res[1:5], setNames, colnames(final.res$iprior)),
      lapply(final.res[6], setNames, "sd"))
  }
  
  cl <- makeCluster(no.cores)
  registerDoSNOW(cl)
  res <- foreach(
    i = 1:nsim, #.combine = combine_sim_res, 
    .packages = c("iprior", "BAS", "glmnet", "rFSA"),
    .export = c("model_codes"),
    .options.snow = list(progress = progress)) %dopar% {
      # Generate data
      Sigma <- matrix(corr, nrow = 3, ncol = 3)
      diag(Sigma) <- 1
      X <- data.frame(mvtnorm::rmvnorm(n, mean = rep(0, 3), sigma = Sigma))
      X_lasso <- model.matrix(~ 0 + X1 * X2 * X3, X)
      y <- as.numeric(X_lasso %*% beta.true) + rnorm(n, sd = err.sd)
      dat <- data.frame(y, X)
      
      # LASSO --------------------------------------------------------------------
      cv_fit <- cv.glmnet(as.matrix(X_lasso), y, nfolds = 10, alpha = 1)
      beta.lasso <- as.numeric(coef(cv_fit))[-1]
      res_lasso <- as.numeric(beta.lasso != 0)
      
      # t-test -------------------------------------------------------------------
      mod <- lm(y ~ X1 * X2 * X3, dat)
      res_lm <- as.numeric(summary(mod)$coefficients[-1, 4] <= 0.1)
      
      # I-prior ------------------------------------------------------------------
      modi <- data.frame(deviance = NA, conv = NA)
      modi[1,  ]  <- iprior_est_same_lambda(y ~ X1, dat)
      modi[2,  ]  <- iprior_est_same_lambda(y ~ X2, dat)
      modi[3,  ]  <- iprior_est_same_lambda(y ~ X3, dat)
      modi[4,  ]  <- iprior_est_same_lambda(y ~ X1 * X2, dat)
      modi[5,  ]  <- iprior_est_same_lambda(y ~ X1 + X2, dat)
      modi[6,  ]  <- iprior_est_same_lambda(y ~ X1 * X3, dat)
      modi[7,  ]  <- iprior_est_same_lambda(y ~ X1 + X3, dat)
      modi[8,  ]  <- iprior_est_same_lambda(y ~ X2 * X3, dat)
      modi[9,  ]  <- iprior_est_same_lambda(y ~ X2 + X3, dat)
      modi[10, ] <- iprior_est_same_lambda(y ~ X1 * X2 * X3, dat)
      modi[11, ] <- iprior_est_same_lambda(y ~ X1 * X2 * X3 - X1:X2:X3, dat)
      modi[12, ] <- iprior_est_same_lambda(y ~ X1 + X2 + X3 + X1:X2 + X1:X3, dat)
      modi[13, ] <- iprior_est_same_lambda(y ~ X1 + X2 + X3 + X1:X2 + X2:X3, dat)
      modi[14, ] <- iprior_est_same_lambda(y ~ X1 + X2 + X3 + X1:X3 + X2:X3, dat)
      modi[15, ] <- iprior_est_same_lambda(y ~ X1 + X2 + X3 + X1:X2, dat)
      modi[16, ] <- iprior_est_same_lambda(y ~ X1 + X2 + X3 + X1:X3, dat)
      modi[17, ] <- iprior_est_same_lambda(y ~ X1 + X2 + X3 + X2:X3, dat)
      modi[18, ] <- iprior_est_same_lambda(y ~ X1 + X2 + X3, dat)
      bestmod <- which(modi[, 1] == min(modi[, 1], na.rm = TRUE))
      res_iprior <- unlist(model_codes[bestmod, -8])
      
      # g-prior ------------------------------------------------------------------
      mod <- bas.lm(y ~ X1 * X2 * X3, dat, force.heredity = TRUE,
                    prior = "EB-local")
      beta.gprior <- coef(mod, n.models = 1)$postmean[-1]
      res_gprior <- as.numeric(beta.gprior != 0)
      
      # Spike and slab -----------------------------------------------------------
      mod <- bas.lm(y ~ X1 * X2 * X3, dat, force.heredity = TRUE,
                    prior = "g-prior", alpha = 100)
      beta.spikeslab <- coef(mod, n.models = 1)$postmean[-1]
      res_spikeslab <- as.numeric(beta.spikeslab != 0)
      
      list(lasso = res_lasso, lm = res_lm, iprior = res_iprior, 
           gprior = res_gprior, spikeslab = res_spikeslab, 
           ipriorconv = modi[bestmod, 2])
    }
  
  close(pb)
  stopCluster(cl)
  
  res <- combine_sim_res(res)

  get_res <- function(x) {
    x %>%
      mutate(mod = apply(x, 1, paste0, collapse = "")) %>%
      rowwise() %>%
      mutate(no = ifelse(length(which(model_codes$code == mod)) > 0,
                         which(model_codes$code == mod), NA)) %>%
      group_by_all() %>%
      summarise(n = n(), prop = n() / nsim) %>%
      arrange(desc(n)) %>%
      ungroup()
  }
  
  the.output <- lapply(res[1:5], get_res)
  the.output$ipriorconv <- mean(res[6]$ipriorconv[, 1] > 1e-4)
  the.output$nsim <- nsim
  the.output$n <- n
  the.output$corr <- corr
  the.output$err.sd <- err.sd
  the.output$beta.true <- beta.true
  the.output
}

## ---- run_sim --------
Nsim <- 10000

# Correlated errors
myres <- list()
for (i in seq_len(nrow(beta_vals))) {
  myres[[i]] <- the_sim_fn(nsim = Nsim, n = 100, corr = 0.5, err.sd = 3,
                           beta.true = beta_vals[i, 1:7] %>% as.numeric())
}

save(myres, file = "simres.RData")

# Uncorrelated errors
myres_uncorr <- list()
for (i in seq_len(nrow(beta_vals))) {
  myres_uncorr[[i]] <- the_sim_fn(nsim = Nsim, n = 100, corr = 0, err.sd = 3,
                                  beta.true = beta_vals[i, 1:7] %>% as.numeric())
}

save(myres_uncorr, file = "simres_uncorr.RData")
