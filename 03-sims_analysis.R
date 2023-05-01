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
  ggradar(group.point.size = 3) 

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
plot_df <-
  bind_rows(
    bind_rows(bind_cols(res_tab1, sim = "Correlated"),
              bind_cols(res_tab2, sim = "Uncorrelated")),
    bind_cols(bind_rows(res_tab1,
                        res_tab2),
              sim = "Overall")
  ) %>%
  pivot_longer(cols = c(iprior, lasso, spikeslab, gprior), names_to = "method",
               values_to = "prop") %>%
  group_by(method, sim) %>%
  summarise(prop = exp(sum(log(prop[prop > 0])) / length(prop)),
            .groups = "drop") %>%
  mutate(method = factor(method, levels = c("iprior", "lasso", "spikeslab", 
                                            "gprior")),
         sim = factor(sim, levels = c("Uncorrelated", "Correlated", "Overall")))

levels(plot_df$method) <- c("I-prior", "Lasso", "Spike & Slab", "g-prior")
levels(plot_df$sim) <- c("Uncorrelated\ncovariates", "Correlated\ncovariates", 
                         "Overall")

plot_df %>%
  filter(sim != "Overall") %>%
  ggplot(aes(method, prop, fill = sim)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = iprior::dec_plac(prop, 2)), vjust = -0.2,
            position = position_dodge(1)) +
  scale_fill_manual(values = my_cols[c(3, 1)]) +
  labs(x = NULL, y = "Proportion correct selection", fill = NULL) +
  theme(axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 11),
        axis.title.y = element_text(size = 12)) +
  theme(legend.spacing.y = unit(0.25, 'cm'))  +
  guides(fill = guide_legend(byrow = TRUE))

# ggsave("simres.pdf", width = 8, height = 4)


