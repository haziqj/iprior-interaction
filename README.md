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

Data pairs $(y_i,x_i)$, where
![x_i\in\mathbb R^3](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;x_i%5Cin%5Cmathbb%20R%5E3 "x_i\in\mathbb R^3"),
were simulated according to the following model

![y_i = \beta_1 x\_{i1}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;y_i%20%3D%20%5Cbeta_1%20x_%7Bi1%7D "y_i = \beta_1 x_{i1}")

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
