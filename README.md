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

The model fitted was an I-prior model with ANOVA kernel (Pearson & fBm).
The results are tabulated below.

### Fixed hurst = 0.5

| model | formula               |   loglik | error | lambda               | psi     | hurst |   k |     AIC |     BIC |
|------:|:----------------------|---------:|------:|:---------------------|:--------|------:|----:|--------:|--------:|
|     1 | `time`                | -2789.23 | 16.25 | 0.837                | 0.00375 |   0.5 |   2 | 5582.46 | 5591.45 |
|     2 | `group * time`        | -2789.20 | 16.24 | 0.019,-0.836         | 0.00375 |   0.5 |   3 | 5584.40 | 5597.88 |
|     3 | `id * time`           | -2295.16 |  2.89 | -0.203,-0.088        | 0.07384 |   0.5 |   3 | 4596.33 | 4609.81 |
|     4 | `(group + id) * time` | -2270.85 |  2.62 | -1.019,-0.187,-0.085 | 0.08711 |   0.5 |   4 | 4549.70 | 4567.67 |
|     5 | `group * id * time`   | -2249.00 |  3.09 | -1.057,4.918,0.047   | 0.06538 |   0.5 |   4 | 4506.00 | 4523.97 |

### Fixed hurst = 0.3

| model | formula               |   loglik | error | lambda              | psi     | hurst |   k |     AIC |     BIC |
|------:|:----------------------|---------:|------:|:--------------------|:--------|------:|----:|--------:|--------:|
|     1 | `time`                | -2792.78 | 16.22 | 4.465               | 0.00375 |   0.3 |   2 | 5589.56 | 5598.54 |
|     2 | `group * time`        | -2792.73 | 16.20 | 0.03,-4.462         | 0.00376 |   0.3 |   3 | 5591.47 | 5604.94 |
|     3 | `id * time`           | -2266.39 |  1.62 | -0.163,-0.381       | 0.13445 |   0.3 |   3 | 4538.79 | 4552.26 |
|     4 | `(group + id) * time` | -2242.30 |  1.44 | 0.708,-0.152,-0.36  | 0.15896 |   0.3 |   4 | 4492.60 | 4510.57 |
|     5 | `group * id * time`   | -2238.78 |  2.16 | -1.184,-1.265,0.248 | 0.09450 |   0.3 |   4 | 4485.56 | 4503.53 |

### Estimated hurst value

| model | formula               |   loglik | error | lambda            | psi     | hurst |   k |     AIC |     BIC |
|------:|:----------------------|---------:|------:|:------------------|:--------|------:|----:|--------:|--------:|
|     1 | `time`                | -2788.77 | 16.28 | 0.347             | 0.00374 |  0.62 |   3 | 5583.53 | 5597.01 |
|     2 | `group * time`        | -2788.75 | 16.27 | 0.013,-0.35       | 0.00375 |  0.61 |   4 | 5585.49 | 5603.46 |
|     3 | `id * time`           | -2253.21 |  0.16 | -0.065,0.83       | 1.24112 |  0.17 |   4 | 4514.43 | 4532.40 |
|     4 | `(group + id) * time` | -2231.13 |  0.13 | 0.102,0.058,0.745 | 1.59394 |  0.18 |   5 | 4472.27 | 4494.73 |
|     5 | `group * id * time`   | -2232.78 |  0.18 | 0.11,0.058,0.751  | 1.19639 |  0.18 |   5 | 4475.55 | 4498.01 |
