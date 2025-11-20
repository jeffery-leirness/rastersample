test_that("spatial_sample works with random method on data.frame", {
  df <- data.frame(x = 1:100, y = rnorm(100))
  result <- spatial_sample(df, n = 10, method = "random")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 10)
  expect_true(all(c("x", "y") %in% names(result)))
})
test_that("spatial_sample works with biased method", {
  df <- data.frame(x = 1:100, y = runif(100))
  result <- spatial_sample(
    df,
    n = 5,
    method = "biased",
    bias_var = "y",
    bias_thresh = 0.5
  )

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 5)
  expect_true(all(result$y > 0.5))
})

test_that("spatial_sample works with stratified method on data.frame", {
  df <- data.frame(
    x = 1:100,
    y = rnorm(100),
    strata = rep(LETTERS[1:5], each = 20)
  )
  result <- spatial_sample(
    df,
    n = 25,
    method = "stratified",
    strata_var = "strata"
  )

  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) >= 25)
  # Each stratum should have approximately n/n_strata samples
  strata_counts <- table(result$strata)
  expect_equal(length(strata_counts), 5)
})

test_that("spatial_sample works with random method on SpatRaster", {
  skip_if_not_installed("terra")

  r <- terra::rast(nrows = 10, ncols = 10)
  terra::values(r) <- 1:100

  result <- spatial_sample(r, n = 10, method = "random")

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 10)
  expect_true("cell" %in% names(result))
})

test_that("spatial_sample returns SpatRaster when as_raster = TRUE", {
  skip_if_not_installed("terra")

  r <- terra::rast(nrows = 10, ncols = 10)
  terra::values(r) <- 1:100

  result <- spatial_sample(r, n = 10, method = "random", as_raster = TRUE)

  expect_s4_class(result, "SpatRaster")
  expect_equal(sum(!is.na(terra::values(result))), 10)
})

test_that("spatial_sample handles NA values correctly", {
  skip_if_not_installed("terra")

  r <- terra::rast(nrows = 10, ncols = 10)
  terra::values(r) <- 1:100
  r[1:20] <- NA

  # With drop_na = TRUE
  result <- spatial_sample(r, n = 10, method = "random", drop_na = TRUE)
  expect_equal(nrow(result), 10)
  expect_true(all(!is.na(result[[2]]))) # Second column contains raster values
})

test_that("spatial_sample with balanced method requires SpatRaster", {
  df <- data.frame(x = 1:100, y = rnorm(100))

  expect_error(
    spatial_sample(df, n = 10, method = "balanced"),
    "x must be a SpatRaster"
  )
})

test_that("spatial_sample with balanced method works on SpatRaster", {
  skip_if_not_installed("terra")
  skip_if_not_installed("MBHdesign")

  r <- terra::rast(nrows = 10, ncols = 10)
  terra::values(r) <- 1:100

  result <- spatial_sample(r, n = 10, method = "balanced")

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 10)
  expect_true("cell" %in% names(result))
})

test_that("spatial_sample with balanced-stratified requires strata_var", {
  skip_if_not_installed("terra")

  r <- terra::rast(nrows = 10, ncols = 10)
  terra::values(r) <- 1:100

  expect_error(
    spatial_sample(r, n = 10, method = "balanced-stratified"),
    "`strata_var` must be specified"
  )
})

test_that("spatial_sample with balanced-stratified works correctly", {
  skip_if_not_installed("terra")
  skip_if_not_installed("MBHdesign")

  r <- terra::rast(nrows = 10, ncols = 10, nlyr = 2)
  terra::values(r[[1]]) <- 1:100
  terra::values(r[[2]]) <- rep(LETTERS[1:5], each = 20)
  names(r) <- c("values", "strata")

  result <- spatial_sample(
    r,
    n = 25,
    method = "balanced-stratified",
    strata_var = "strata"
  )

  expect_s3_class(result, "tbl_df")
  # Balanced sampling may return approximately n samples, not exactly n
  expect_true(nrow(result) >= 20 && nrow(result) <= 30)
  expect_true("strata" %in% names(result))
})

test_that("spatial_sample with clh method works", {
  skip_if_not_installed("clhs")

  df <- data.frame(
    x = rnorm(100),
    y = rnorm(100),
    z = rnorm(100)
  )

  result <- spatial_sample(
    df,
    n = 10,
    method = "clh",
    clh_var = c("x", "y", "z"),
    clh_iter = 1000
  )

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 10)
})

test_that("spatial_sample with type = 'line' requires SpatRaster", {
  df <- data.frame(x = 1:100, y = rnorm(100))

  expect_error(
    spatial_sample(df, n = 5, method = "random", type = "line"),
    "x must be a SpatRaster"
  )
})

test_that("spatial_sample with type = 'line' requires valid method", {
  skip_if_not_installed("terra")

  r <- terra::rast(nrows = 10, ncols = 10)
  terra::values(r) <- 1:100

  expect_error(
    spatial_sample(r, n = 5, method = "stratified", type = "line"),
    "`method` must be either 'random' or 'balanced'"
  )
})

test_that("spatial_sample with type = 'line' and method = 'random' works", {
  skip_if_not_installed("terra")
  skip_if_not_installed("MBHdesign")

  r <- terra::rast(nrows = 20, ncols = 20)
  terra::values(r) <- 1:400

  result <- spatial_sample(r, n = 3, method = "random", type = "line")

  expect_s3_class(result, "tbl_df")
  expect_true(all(c("x", "y", "cell") %in% names(result)))
  expect_true(nrow(result) > 0)
})

test_that("spatial_sample with type = 'line' and method = 'balanced' works", {
  skip_if_not_installed("terra")
  skip_if_not_installed("MBHdesign")

  r <- terra::rast(nrows = 20, ncols = 20)
  terra::values(r) <- 1:400

  result <- spatial_sample(r, n = 3, method = "balanced", type = "line")

  expect_s3_class(result, "tbl_df")
  expect_true(all(c("x", "y", "cell") %in% names(result)))
  expect_true(nrow(result) > 0)
})

test_that("spatial_sample respects sample size n", {
  df <- data.frame(x = 1:100, y = rnorm(100))

  for (n in c(5, 10, 20, 50)) {
    result <- spatial_sample(df, n = n, method = "random")
    expect_equal(nrow(result), n)
  }
})

test_that("spatialsample_random returns correct sample size", {
  df <- data.frame(x = 1:100, y = rnorm(100))
  result <- rastersample:::spatialsample_random(df, n = 15)

  expect_equal(nrow(result), 15)
})

test_that("spatialsample_biased filters and samples correctly", {
  df <- data.frame(x = 1:100, value = runif(100))
  result <- rastersample:::spatialsample_biased(
    df,
    n = 5,
    var = "value",
    thresh = 0.7
  )

  expect_equal(nrow(result), 5)
  expect_true(all(result$value > 0.7))
})

test_that("spatialsample_stratified distributes samples across strata", {
  df <- data.frame(
    x = 1:100,
    strata = rep(LETTERS[1:4], each = 25)
  )
  result <- rastersample:::spatialsample_stratified(df, n = 20, var = "strata")

  # Should have approximately 5 samples per stratum (20/4 = 5)
  strata_counts <- table(result$strata)
  expect_equal(length(strata_counts), 4)
  expect_true(all(strata_counts >= 5))
})
