
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rastersample

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

## Overview

The `rastersample` package provides simple functions for sampling
spatial data according to various sampling methods. It supports working
with both tabular data (`data.frame`) and raster data (`SpatRaster`),
making it a versatile tool for spatial data analysis and sampling design
in ecological and environmental research.

## Features

- Multiple sampling methods:
  - Random sampling
  - Biased sampling based on threshold values
  - Stratified random sampling
  - Conditioned Latin hypercube sampling
  - Spatially balanced sampling
  - Spatially balanced stratified sampling
- Works with both `data.frame` and `SpatRaster` objects
- Options to filter NA values before sampling
- Flexible output as either data frames or rasters

## Installation

You can install the development version of rastersample from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jeffery-leirness-noaa/rastersample")
#> Downloading GitHub repo jeffery-leirness-noaa/rastersample@HEAD
#> rlang        (1.1.5    -> 1.1.6   ) [CRAN]
#> cli          (3.6.4    -> 3.6.5   ) [CRAN]
#> rngWELL      (NA       -> 0.10-10 ) [CRAN]
#> RcppProgress (NA       -> 0.4.2   ) [CRAN]
#> linprog      (NA       -> 0.9-4   ) [CRAN]
#> lpSolve      (NA       -> 5.6.23  ) [CRAN]
#> magic        (NA       -> 1.6-1   ) [CRAN]
#> scales       (1.3.0    -> 1.4.0   ) [CRAN]
#> randtoolbox  (NA       -> 2.0.5   ) [CRAN]
#> geometry     (NA       -> 0.5.2   ) [CRAN]
#> RcppArmad... (14.4.1-1 -> 14.4.2-1) [CRAN]
#> reshape2     (NA       -> 1.4.4   ) [CRAN]
#> MBHdesign    (NA       -> 2.3.15  ) [CRAN]
#> clhs         (NA       -> 0.9.0   ) [CRAN]
#> Installing 14 packages: rlang, cli, rngWELL, RcppProgress, linprog, lpSolve, magic, scales, randtoolbox, geometry, RcppArmadillo, reshape2, MBHdesign, clhs
#> Installing packages into '/usr/local/lib/R/site-library'
#> (as 'lib' is unspecified)
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/tmp/Rtmpn6FMd2/remotes1a830a975ee/jeffery-leirness-noaa-rastersample-b5e944c/DESCRIPTION’ ...  ✔  checking for file ‘/tmp/Rtmpn6FMd2/remotes1a830a975ee/jeffery-leirness-noaa-rastersample-b5e944c/DESCRIPTION’
#>   ─  preparing ‘rastersample’:
#>    checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts (379ms)
#>   ─  checking for empty or unneeded directories
#>        NB: this package now depends on R (>= 4.1.0)
#>        WARNING: Added dependency on R >= 4.1.0 because package code uses the
#>      pipe |> or function shorthand \(...) syntax added in R 4.1.0.
#>      File(s) using such syntax:
#>        ‘spatial_sample.R’ ‘stratify.R’
#> ─  building ‘rastersample_0.0.0.9000.tar.gz’
#>      
#> 
#> Installing package into '/usr/local/lib/R/site-library'
#> (as 'lib' is unspecified)
```

## Usage

``` r
# Create a sample raster
r <- terra::rast(nrows = 10, ncols = 10, xmin = 0, xmax = 10, ymin = 0,
                 ymax = 10)
terra::values(r) <- 1:100

# Take a random sample of 10 cells
random_sample <- rastersample::spatial_sample(r, n = 10, method = "random")

# Take a biased sample (cells with values > 80)
biased_sample <- rastersample::spatial_sample(r, n = 5, method = "biased",
                                              bias_var = "lyr.1",
                                              bias_thresh = 80)

# Create a stratified raster
strata <- r
terra::values(strata) <- rep(1:5, each=20)

# Take a stratified random sample
stratified_sample <- rastersample::spatial_sample(r, n = 10,
                                                  method = "stratified",
                                                  strata_var = "lyr.1")

# Return results as a raster
sample_rast <- rastersample::spatial_sample(r, n = 10, method = "random", 
                                            as_raster = TRUE)
```

## Getting help

If you encounter a bug, please file an issue with a minimal reproducible
example on GitHub.

## Disclaimer

This repository is a scientific product and is not official
communication of the National Oceanic and Atmospheric Administration, or
the United States Department of Commerce. All NOAA GitHub project code
is provided on an ‘as is’ basis and the user assumes responsibility for
its use. Any claims against the Department of Commerce or Department of
Commerce bureaus stemming from the use of this GitHub project will be
governed by all applicable Federal law. Any reference to specific
commercial products, processes, or services by service mark, trademark,
manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce.
The Department of Commerce seal and logo, or the seal and logo of a DOC
bureau, shall not be used in any manner to imply endorsement of any
commercial product or activity by DOC or the United States Government.

## License

Software code created by U.S. Government employees is not subject to
copyright in the United States (17 U.S.C. §105). The United
States/Department of Commerce reserve all rights to seek and obtain
copyright protection in countries other than the United States for
Software authored in its entirety by the Department of Commerce. To this
end, the Department of Commerce hereby grants to Recipient a
royalty-free, nonexclusive license to use, copy, and create derivative
works of the Software outside of the United States.
