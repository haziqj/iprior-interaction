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

Data pairs
![(y_i,x_i)](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%28y_i%2Cx_i%29 "(y_i,x_i)"),
where
![x_i\in\mathbb R^3](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;x_i%5Cin%5Cmathbb%20R%5E3 "x_i\in\mathbb R^3")
for
![i=1,\dots,n](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;i%3D1%2C%5Cdots%2Cn "i=1,\dots,n"),
were simulated according to the following model

![y_i = \beta_1 x\_{i1} + \beta_2 x\_{i2} + \beta_3 x\_{i3} + \beta_4 x\_{i1}x\_{i2} + \beta_5 x\_{i1}x\_{i3} + + \beta_6 x\_{i2}x\_{i3} + \beta_7 x\_{i1}x\_{i2}x\_{i3} + \epsilon_i](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;y_i%20%3D%20%5Cbeta_1%20x_%7Bi1%7D%20%2B%20%5Cbeta_2%20x_%7Bi2%7D%20%2B%20%5Cbeta_3%20x_%7Bi3%7D%20%2B%20%5Cbeta_4%20x_%7Bi1%7Dx_%7Bi2%7D%20%2B%20%5Cbeta_5%20x_%7Bi1%7Dx_%7Bi3%7D%20%2B%20%2B%20%5Cbeta_6%20x_%7Bi2%7Dx_%7Bi3%7D%20%2B%20%5Cbeta_7%20x_%7Bi1%7Dx_%7Bi2%7Dx_%7Bi3%7D%20%2B%20%5Cepsilon_i "y_i = \beta_1 x_{i1} + \beta_2 x_{i2} + \beta_3 x_{i3} + \beta_4 x_{i1}x_{i2} + \beta_5 x_{i1}x_{i3} + + \beta_6 x_{i2}x_{i3} + \beta_7 x_{i1}x_{i2}x_{i3} + \epsilon_i")

where
![\epsilon_i\sim N(0,\sigma^2)](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Cepsilon_i%5Csim%20N%280%2C%5Csigma%5E2%29 "\epsilon_i\sim N(0,\sigma^2)")
such that
![\text{Corr}(\epsilon_i,\epsilon_j)=\rho](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Ctext%7BCorr%7D%28%5Cepsilon_i%2C%5Cepsilon_j%29%3D%5Crho "\text{Corr}(\epsilon_i,\epsilon_j)=\rho"),
for
![i\neq j](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;i%5Cneq%20j "i\neq j").
The simulation settings were
![n=100](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;n%3D100 "n=100"),
![\sigma=3](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Csigma%3D3 "\sigma=3"),
![\rho\in\\{0,0.5\\}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Crho%5Cin%5C%7B0%2C0.5%5C%7D "\rho\in\{0,0.5\}"),
and the simulations were repeated for a total of
![B=10,000](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;B%3D10%2C000 "B=10,000")
times.

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
