library(glinternet)
library(glmnet)
library(tidyverse)
options(dplyr.summarise.inform = FALSE)
library(BAS)
library(doSNOW)
library(iprior)
library(ggradar)
theme_set(theme_classic())



## ---- simres_fn --------
res_cleanup <- function(x) {
  # mutate(x, no = ifelse(prop < 0.05, NA, no)) %>%
  #   drop_na()
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
  replace(is.na(.), 0) -> res_tab1

# Radar plot
res_tab %>%
  pivot_wider(names_from = mod, values_from = prop) %>%
  replace(is.na(.), 0) %>%
  ggradar()

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
  replace(is.na(.), 0) -> res_tab2

# Radar plot
res_tab %>%
  pivot_wider(names_from = mod, values_from = prop) %>%
  replace(is.na(.), 0) %>%
  ggradar(group.point.size = 3)

## ---- overall_plot ----
bind_rows(
  bind_rows(
    bind_cols(res_tab1, sim = "Correlated"),
    bind_cols(res_tab2, sim = "Uncorrelated")
  ),
  bind_cols(
    bind_rows(
      res_tab1,
      res_tab2
    ),
    sim = "Overall"
  )
) %>%
  pivot_longer(cols = c(iprior, lasso, spikeslab, gprior), names_to = "method",
               values_to = "prop") %>%
  group_by(method, sim) %>%
  summarise(prop = exp(sum(log(prop[prop > 0])) / length(prop))) %>%
  mutate(method = factor(method, levels = c("iprior", "lasso", "spikeslab", "gprior")),
         sim = factor(sim, levels = c("Uncorrelated", "Correlated", "Overall"))) -> plot_df

levels(plot_df$method) <- c("I-prior", "Lasso", "Spike & Slab", "g-prior")


ggplot(plot_df, aes(method, prop, fill = sim)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_viridis_d() +
  labs(x = NULL, y = "Proportion correct selection", fill = NULL) -> p

ggsave("simres.pdf", p, width = 8, height = 4)


