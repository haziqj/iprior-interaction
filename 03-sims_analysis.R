library(glinternet)
library(glmnet)
library(tidyverse)
options(dplyr.summarise.inform = FALSE)
library(BAS)
library(doSNOW)
library(iprior)
theme_set(theme_classic())



## ---- simres_fn --------
res_cleanup <- function(x) {
  mutate(x, no = ifelse(prop < 0.05, NA, no)) %>%
    drop_na()
  x
}

res_final_tab <- function(x, true.mod = "1111111") {
  the.names <- names(x[c("iprior", "lasso", "spikeslab", "gprior")])
  do.call(bind_rows, mapply(cbind, x[c("iprior", "lasso", "spikeslab", "gprior")], 
                            "method" = the.names, SIMPLIFY = F)) %>%
    mutate(method = factor(method, levels = the.names)) %>%
    filter(mod == true.mod) %>%
    group_by(method) %>%
    select(mod, prop) 
}

## ---- simres1 ----
load("simres.RData")
res_tab <- NULL
for (i in seq_len(length(myres))) {
  res_tab <- bind_rows(res_tab,
                       res_final_tab(myres[[i]], beta_vals[i, 8, drop = TRUE]) 
  )
}
res_tab %>% 
  pivot_wider(names_from = method, values_from = prop) %>%
  replace(is.na(.), 0) -> res_tab

## ---- simres2 ----
load("simres_uncorr.RData")
res_tab <- NULL
for (i in seq_len(length(myres_uncorr))) {
  res_tab <- bind_rows(res_tab,
                       res_final_tab(myres_uncorr[[i]], beta_vals[i, 8, drop = TRUE]) 
  )
}
res_tab %>% 
  pivot_wider(names_from = method, values_from = prop) %>%
  replace(is.na(.), 0) -> res_tab

