# Unit Tests for rastersample

This directory contains comprehensive unit tests for the rastersample R package using the testthat framework.

## Test Files

### `test-spatial-sample.R`
Tests for the `spatial_sample()` function and its internal helper functions:

- **Basic sampling methods:**
  - Random sampling on data.frames and SpatRasters
  - Biased sampling with threshold filtering
  - Stratified sampling across different strata
  - Conditioned Latin Hypercube (CLH) sampling
  - Spatially balanced sampling
  - Stratified spatially balanced sampling

- **Line/transect sampling:**
  - Random line sampling
  - Balanced line sampling
  - Validation of transect-specific requirements

- **Input/output validation:**
  - NA handling with `drop_na` parameter
  - Return type control with `as_raster` parameter
  - Sample size verification
  - Error handling for invalid method/type combinations

- **Internal function tests:**
  - `spatialsample_random()`
  - `spatialsample_biased()`
  - `spatialsample_stratified()`

**Total tests:** 28 tests covering 43 assertions

### `test-stratify.R`
Tests for the `stratify()` function:

- **Equal-split stratification:**
  - Numeric vectors
  - SpatRaster objects
  - Consistent quantile-based breaks

- **Custom stratification:**
  - Using probability cutpoints
  - Using explicit value breaks
  - Validation of break point lengths

- **Edge cases:**
  - NA value handling in rasters
  - Layer naming conventions
  - Consistency across repeated calls

- **Error handling:**
  - Invalid parameter combinations
  - Incorrect break point specifications

**Total tests:** 11 tests covering 22 assertions

## Running Tests

### Run all tests:
```r
devtools::test()
```

### Run tests for a specific file:
```r
testthat::test_file("tests/testthat/test-spatial-sample.R")
testthat::test_file("tests/testthat/test-stratify.R")
```

### Run a specific test:
```r
testthat::test_file("tests/testthat/test-spatial-sample.R", 
                     filter = "random method")
```

## Test Coverage

The tests cover:
- ✅ All main sampling methods (random, biased, stratified, clh, balanced, balanced-stratified)
- ✅ Both point and line sampling types
- ✅ Both data.frame and SpatRaster inputs
- ✅ All stratification methods (equal-split, probability-based, value-based)
- ✅ Error handling for invalid inputs
- ✅ NA value handling
- ✅ Internal helper functions

## Dependencies

Tests require the following packages:
- testthat (>= 3.0.0)
- terra
- dplyr
- tibble
- tidyr
- clhs (for CLH sampling tests)
- MBHdesign (for balanced and transect sampling tests)

## Notes

- Some tests use `skip_if_not_installed()` to gracefully skip tests when optional dependencies are missing
- Balanced sampling methods may return approximately `n` samples rather than exactly `n` due to the nature of the algorithm
- Line sampling tests produce verbose output from `MBHdesign::transectSamp()` showing iteration progress
