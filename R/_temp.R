r <- system.file("ex/elev.tif", package = "terra") |>
  terra::rast()

# working example
samp <- spatial_sample(
  r,
  n = 10,
  method = "balanced",
  drop_na = TRUE,
  as_raster = FALSE,
  type = "line",
  control = list(
    transect.nPts = 5,
    # line.length = 5000,  # cannot get this to run without errors
    nRotate = 5,
    mc.cores = 10
    # edge.max.iter = 50,
    # return.index = TRUE
  )
)
v <- samp |>
  sf::st_as_sf(coords = c("x", "y"), crs = sf::st_crs(r)) |>
  dplyr::group_by(transect) |>
  dplyr::summarise(do_union = FALSE) |>
  sf::st_cast("LINESTRING") |>
  terra::vect()
terra::plot(r)
terra::plot(v, add = TRUE)

# check length of transect lines
samp$points |>
  sf::st_as_sf(coords = c("x", "y"), crs = sf::st_crs(r)) |>
  dplyr::group_by(transect) |>
  dplyr::summarise(do_union = FALSE) |>
  sf::st_cast("LINESTRING") |>
  sf::st_length()

# test effects of specifying a study area
sa <- sf::st_bbox(r) |>
  sf::st_as_sfc() |>
  sf::st_coordinates() |>
  tibble::as_tibble() |>
  dplyr::select(X:Y) |>
  as.matrix()
# r_ip <- terra::noNA(r) * 1
r[!is.na(r)] <- 1
sa <- terra::as.polygons(r) |>
  sf::st_as_sf() |>
  sf::st_coordinates() |>
  tibble::as_tibble() |>
  dplyr::filter(L1 == 1 & L2 == 2) |>
  dplyr::select(X:Y) |>
  as.matrix()
samp <- MBHdesign::transectSamp(
  n = 10,
  study.area = sa,
  control = list(transect.pattern = "line",
                 nRotate = 5,
                 transect.nPts = 5,
                 mc.cores = 10)
)
