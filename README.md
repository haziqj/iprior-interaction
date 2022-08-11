I-priors and interactions
================

This contains the R code for our paper.

> Wicher Bergsma, Haziq Jamil (2022). *Additive interaction modelling
> using I-priors*.

The key documents are

1.  `02-sims.R` and `03-sims_analysis.R` contains the code for the
    simulations in Section 5.
2.  `01-cow.R` contains the code for the functional response model in
    Section 6.

In this README, the main summary of findings are presented. Full details
of the simulation results are found in the pdf files `simres_corr.pdf`
and `simres_uncorr.pdf`.

## Simulations

Data pairs $(y_i,x_i)$, where $x_i\in\mathbb R^3$ for $i=1,\dots,n$,
were simulated according to the following model

$$ y_i = \beta_1 x\_{i1} + \beta_2 x\_{i2} + \beta_3 x\_{i3} + \beta_4
x\_{i1}x\_{i2} + \beta_5 x\_{i1}x\_{i3} + \beta_6 x\_{i2}x\_{i3} +
\beta_7 x\_{i1}x\_{i2}x\_{i3} + \epsilon_i $$

where $\epsilon_i\sim N(0,\sigma^2)$ such that
$\text{Corr}(\epsilon_i,\epsilon_j)=\rho$, for $i\neq j$. The simulation
settings were $n=100$, $\sigma=3$, $\rho\in\\{0,0.5\\}$. The
coefficients were varied according to the table below

|     |  x1 |  x2 |  x3 | x1x2 | x1x3 | x2x3 | x1x2x3 | code    |
|:----|----:|----:|----:|-----:|-----:|-----:|-------:|:--------|
| 1   |   1 |   0 |   0 |  0.0 |  0.0 |  0.0 |   0.00 | 1000000 |
| 2   |   1 |   1 |   0 |  0.0 |  0.0 |  0.0 |   0.00 | 1100000 |
| 3   |   1 |   1 |   0 |  0.5 |  0.0 |  0.0 |   0.00 | 1101000 |
| 4   |   1 |   1 |   1 |  0.0 |  0.0 |  0.0 |   0.00 | 1110000 |
| 5   |   1 |   1 |   1 |  0.0 |  0.5 |  0.0 |   0.00 | 1110100 |
| 6   |   1 |   1 |   1 |  0.5 |  0.5 |  0.0 |   0.00 | 1111100 |
| 7   |   1 |   1 |   1 |  0.5 |  0.5 |  0.5 |   0.00 | 1111110 |
| 8   |   1 |   1 |   1 |  0.5 |  0.5 |  0.5 |   0.25 | 1111111 |

For each set of true values of the coefficients, the four methods
proposed the likeliest model to have generated the data set, from a
search of hierarchically nested interaction models. This was replicated
a total of $B=10,000$ times for each true value set.

The results below show proportion of times that each method selected the
true model (higher is better).

### Uncorrelated errors

![](figure/sims_uncorr-1.png)<!-- -->

|     | mod     | iprior | lasso | spikeslab | gprior |
|:----|:--------|-------:|------:|----------:|-------:|
| 1   | 1000000 |   0.69 |  0.21 |      0.56 |   0.45 |
| 2   | 1100000 |   0.55 |  0.33 |      0.32 |   0.29 |
| 3   | 1101000 |   0.52 |  0.11 |      0.02 |   0.04 |
| 4   | 1110000 |   0.33 |  0.37 |      0.18 |   0.13 |
| 5   | 1110100 |   0.32 |  0.15 |      0.01 |   0.01 |
| 6   | 1111100 |   0.26 |  0.09 |      0.00 |   0.00 |
| 7   | 1111110 |   0.16 |  0.08 |      0.00 |   0.00 |
| 8   | 1111111 |   0.19 |  0.06 |      0.00 |   0.98 |

The geometric mean

    ##    iprior     lasso spikeslab    gprior 
    ##     0.337     0.146     0.031     0.204

### Correlated errors

![](figure/sims_corr-1.png)<!-- -->

|     | mod     | iprior | lasso | spikeslab | gprior |
|:----|:--------|-------:|------:|----------:|-------:|
| 1   | 1000000 |   0.64 |  0.20 |      0.55 |   0.46 |
| 2   | 1100000 |   0.54 |  0.43 |      0.11 |   0.27 |
| 3   | 1101000 |   0.48 |  0.09 |      0.01 |   0.09 |
| 4   | 1110000 |   0.43 |  0.52 |      0.01 |   0.16 |
| 5   | 1110100 |   0.31 |  0.10 |      0.00 |   0.07 |
| 6   | 1111100 |   0.27 |  0.10 |      0.00 |   0.00 |
| 7   | 1111110 |   0.18 |  0.13 |      0.00 |   0.00 |
| 8   | 1111111 |   0.43 |  0.16 |      0.00 |   0.78 |

The geometric mean

    ##    iprior     lasso spikeslab    gprior 
    ##     0.383     0.172     0.107     0.136

## Functional response model

![](figure/cow_plot-1.png)<!-- -->
