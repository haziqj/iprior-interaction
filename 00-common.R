# Install packages (if needed)
# pak::pkg_install("haziqj/iprior")
# pak::pkg_install("haziqj/ipriorBVS")

# Load libraries
library(tidyverse)
theme_set(theme_classic())
library(kableExtra)
library(ggradar)
library(doSNOW)
library(foreach)
library(iprior)
library(ipriorBVS)
library(BAS)
library(glinternet)
library(glmnet)

my_cols <- c("#FF5A5F", "#FFB400", "#007A87", "#8CE071", "#7B0051", "#00D1C1",
             "#FFAA91", "#B4A76C", "#9CA299", "#565A5C", "#00A04B", "#E54C20")
