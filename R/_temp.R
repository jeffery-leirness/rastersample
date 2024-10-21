r <- system.file("ex/elev.tif", package = "terra") |>
  terra::rast()

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

samp <- MBHdesign::transectSamp(n = 10,
                                study.area = sa,
                                control = list(transect.pattern = "line",
                                               nRotate = 5,
                                               transect.nPts = 5,
                                               mc.cores = 2))
# r_ip <- terra::noNA(r) * 1
r_ip <- r
r_ip[!is.na(r_ip)] <- 1
g <- sf::st_bbox(r) |>
  sf::st_make_grid(n = c(100, 100), what = "centers")
g_ip <- terra::extract(r_ip, terra::vect(g), ID = FALSE)[, 1]

samp <- MBHdesign::transectSamp(n = 10,
                                potential.sites = sf::st_coordinates(g),
                                inclusion.probs = g_ip,
                                control = list(transect.pattern = "line",
                                               nRotate = 5,
                                               transect.nPts = 5,
                                               mc.cores = 2,
                                               spat.random.type = "pseudo"))


v <- samp$points |>
  sf::st_as_sf(coords = c("X", "Y"), crs = sf::st_crs(r)) |>
  dplyr::group_by(transect) |>
  dplyr::summarise(do_union = FALSE) |>
  sf::st_cast("LINESTRING") |>
  terra::vect()

terra::plot(r)
terra::plot(v, add = TRUE)

