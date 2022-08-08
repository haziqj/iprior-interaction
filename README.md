I-priors and interactions
================

This contains the R code for our paper.

> Wicher Bergsma, Haziq Jamil (2022). *Additive interaction modelling
> using I-priors*.

The key documents are

1.  `01-cow.R` contains the code for the functional response model in
    Section 6.
2.  `02-sims.R` contains the code for the simulations in Section 5.

In this README, the main summary of findings are presented.

## Simulations

Data pairs $(y_i,x_i)$, where $x_i\in\mathbb R^3$ for $i=1,\dots,n$,
were simulated according to the following model

$$ y_i = \beta_1 x\_{i1} + \beta_2 x\_{i2} + \beta_3 x\_{i3} + \beta_4
x\_{i1}x\_{i2} + \beta_5 x\_{i1}x\_{i3} + \beta_6 x\_{i2}x\_{i3} +
\beta_7 x\_{i1}x\_{i2}x\_{i3} + \epsilon_i $$

where $\epsilon_i\sim N(0,\sigma^2)$ such that
$\text{Corr}(\epsilon_i,\epsilon_j)=\rho$, for $i\neq j$. The simulation
settings were $n=100$, $$, ${0,0.5}$, and the simulations were repeated
for a total of $B=10,000$ times.

The coefficients for the simulations were as follows.

|  x1 |  x2 |  x3 | x1x2 | x1x3 | x2x3 | x1x2x3 |
|----:|----:|----:|-----:|-----:|-----:|-------:|
|   1 |   0 |   0 |  0.0 |  0.0 |  0.0 |   0.00 |
|   1 |   1 |   0 |  0.0 |  0.0 |  0.0 |   0.00 |
|   1 |   1 |   0 |  0.5 |  0.0 |  0.0 |   0.00 |
|   1 |   1 |   1 |  0.0 |  0.0 |  0.0 |   0.00 |
|   1 |   1 |   1 |  0.0 |  0.5 |  0.0 |   0.00 |
|   1 |   1 |   1 |  0.5 |  0.5 |  0.0 |   0.00 |
|   1 |   1 |   1 |  0.5 |  0.5 |  0.5 |   0.00 |
|   1 |   1 |   1 |  0.5 |  0.5 |  0.5 |   0.25 |

## Functional response model
