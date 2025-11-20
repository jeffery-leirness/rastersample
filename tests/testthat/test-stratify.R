test_that("stratify works with numeric vectors and equal splits", {
  x <- 1:100
  result <- stratify(x, n_strata = 4)

  expect_type(result, "integer")
  expect_length(result, 100)
  expect_equal(unique(result), 1:4)
  expect_true(all(result >= 1 & result <= 4))
})

test_that("stratify works with custom probabilities", {
  x <- 1:100
  result <- stratify(
    x,
    n_strata = 3,
    equal_split = FALSE,
    probs = c(0.33, 0.67)
  )

  expect_type(result, "integer")
  expect_length(result, 100)
  expect_equal(unique(result), 1:3)
})

test_that("stratify works with custom values", {
  x <- 1:100
  result <- stratify(x, n_strata = 3, equal_split = FALSE, vals = c(34, 67))

  expect_type(result, "integer")
  expect_length(result, 100)
  expect_equal(unique(result), 1:3)
})

test_that("stratify works with SpatRaster objects", {
  skip_if_not_installed("terra")

  r <- terra::rast(nrows = 10, ncols = 10)
  terra::values(r) <- 1:100

  result <- stratify(r, n_strata = 4)

  expect_s4_class(result, "SpatRaster")
  expect_equal(terra::nlyr(result), 1)
  expect_true(all(terra::values(result) %in% 1:4))
})

test_that("stratify handles NA values in SpatRaster", {
  skip_if_not_installed("terra")

  r <- terra::rast(nrows = 10, ncols = 10)
  terra::values(r) <- 1:100
  r[1:10] <- NA

  result <- stratify(r, n_strata = 4)

  expect_s4_class(result, "SpatRaster")
  expect_equal(sum(is.na(terra::values(result))), 10)
})

test_that("stratify throws errors for invalid inputs", {
  x <- 1:100

  # Both probs and vals specified
  expect_error(
    stratify(
      x,
      n_strata = 3,
      equal_split = FALSE,
      probs = c(0.33, 0.67),
      vals = c(34, 67)
    ),
    "Both `probs` and `vals` are non-NULL"
  )

  # equal_split TRUE but probs/vals specified
  expect_error(
    stratify(x, n_strata = 3, equal_split = TRUE, probs = c(0.33, 0.67)),
    "If `equal_split`, both `probs` and `vals` must be NULL"
  )

  # equal_split FALSE but neither probs nor vals specified
  expect_error(
    stratify(x, n_strata = 3, equal_split = FALSE),
    "If NOT `equal_split`, either `probs` or `vals` must be specified"
  )

  # Wrong length for probs
  expect_error(
    stratify(x, n_strata = 3, equal_split = FALSE, probs = c(0.5)),
    "Length of `probs` should equal the number of splits"
  )

  # Wrong length for vals
  expect_error(
    stratify(x, n_strata = 3, equal_split = FALSE, vals = c(50)),
    "Length of `vals` should equal the number of splits"
  )
})

test_that("stratify produces consistent results", {
  x <- rnorm(100, mean = 50, sd = 10)
  result1 <- stratify(x, n_strata = 5)
  result2 <- stratify(x, n_strata = 5)

  expect_equal(result1, result2)
})

test_that("stratify names SpatRaster layers correctly", {
  skip_if_not_installed("terra")

  r <- terra::rast(nrows = 10, ncols = 10)
  names(r) <- "elevation"
  terra::values(r) <- 1:100

  result <- stratify(r, n_strata = 4)

  expect_equal(names(result), "elevation_strata")
})
