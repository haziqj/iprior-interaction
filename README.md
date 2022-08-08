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

Data pairs (*y*<sub>*i*</sub>,*x*<sub>*i*</sub>), where
*x*<sub>*i*</sub> ∈ ℝ<sup>3</sup> for *i* = 1, …, *n*, were simulated
according to the following model

*y*<sub>*i*</sub> = *β*<sub>1</sub>*x*<sub>*i*1</sub> + *β*<sub>2</sub>*x*<sub>*i*2</sub> + *β*<sub>3</sub>*x*<sub>*i*3</sub> + *β*<sub>4</sub>*x*<sub>*i*1</sub>*x*<sub>*i*2</sub> + *β*<sub>5</sub>*x*<sub>*i*1</sub>*x*<sub>*i*3</sub> +  + *β*<sub>6</sub>*x*<sub>*i*2</sub>*x*<sub>*i*3</sub> + *β*<sub>7</sub>*x*<sub>*i*1</sub>*x*<sub>*i*2</sub>*x*<sub>*i*3</sub> + *ϵ*<sub>*i*</sub>

where *ϵ*<sub>*i*</sub> ∼ *N*(0,*σ*<sup>2</sup>) such that
Corr(*ϵ*<sub>*i*</sub>,*ϵ*<sub>*j*</sub>) = *ρ*, for *i* ≠ *j*. The
simulation settings were *n* = 100, *σ* = 3, *ρ* ∈ {0, 0.5}, and the
simulations were repeated for a total of *B* = 10, 000 times.

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
