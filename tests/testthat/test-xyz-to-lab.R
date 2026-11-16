test_that("xyz_to_lab converts the D65 reference white to neutral white", {
  XYZ <- data.frame(X = 95.047, Y = 100, Z = 108.883)
  lab <- xyz_to_lab(XYZ)

  expect_equal(lab$L, 100, tolerance = 1e-10)
  expect_equal(lab$a, 0, tolerance = 1e-10)
  expect_equal(lab$b, 0, tolerance = 1e-10)
})

test_that("xyz_to_lab applies the direct CIELAB equations", {
  XYZ <- data.frame(X = 41.24, Y = 21.26, Z = 1.93)
  lab <- xyz_to_lab(XYZ)

  delta <- 6 / 29
  f <- function(t) {
    if (t > delta^3) t^(1 / 3) else t / (3 * delta^2) + 4 / 29
  }
  fx <- f(41.24 / 95.047)
  fy <- f(21.26 / 100)
  fz <- f(1.93 / 108.883)

  expect_equal(lab$L, 116 * fy - 16, tolerance = 1e-12)
  expect_equal(lab$a, 500 * (fx - fy), tolerance = 1e-12)
  expect_equal(lab$b, 200 * (fy - fz), tolerance = 1e-12)
})

test_that("xyz_to_lab accepts matrices and propagates missing values", {
  XYZ <- matrix(
    c(95.047, 100, 108.883,
      NA, 50, 40),
    nrow = 2, byrow = TRUE
  )
  lab <- xyz_to_lab(XYZ)

  expect_equal(lab$L[1], 100, tolerance = 1e-10)
  
  # Missing X affects a* but not L* or b*
  expect_true(is.finite(lab$L[2]))
  expect_true(is.na(lab$a[2]))
  expect_true(is.finite(lab$b[2]))
})

test_that("spectra_to_rgb_lab calculates Lab independently from RGB", {
  wl <- seq(400, 700, by = 10)
  spectra <- rbind(
    rep(0.35, length(wl)),
    seq(0.1, 0.7, length.out = length(wl))
  )
  df <- as.data.frame(spectra)
  names(df) <- as.character(wl)

  combined <- spectra_to_rgb_lab(df)
  lab_only <- spectra_to_lab(df)

  expect_equal(combined[, c("L", "a", "b")],
               lab_only[, c("L", "a", "b")],
               tolerance = 1e-12)
})
