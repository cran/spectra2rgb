#' Convert CIE XYZ directly to CIELAB
#'
#' Converts CIE XYZ tristimulus values directly to CIELAB coordinates
#' using the specified reference white. This calculation does not pass
#' through sRGB and therefore does not introduce sRGB gamut clipping,
#' gamma encoding, or 8-bit quantization.
#'
#' @param XYZ A data.frame with columns \code{X}, \code{Y}, \code{Z}, or
#'   a numeric matrix with 3 columns. XYZ values and \code{white} must use
#'   the same scale.
#' @param white Reference white point, expressed on the same scale as
#'   \code{XYZ}. Defaults to D65
#'   (\code{c(X = 95.047, Y = 100, Z = 108.883)}).
#'
#' @return A data.frame with numeric columns \code{L}, \code{a}, \code{b}.
#'
#' @details
#' The standard CIELAB piecewise function is applied to the ratios
#' \eqn{X/X_n}, \eqn{Y/Y_n}, and \eqn{Z/Z_n}. Missing XYZ values propagate
#' to the corresponding output coordinates.
#'
#' @export
xyz_to_lab <- function(XYZ, white = c(X = 95.047, Y = 100, Z = 108.883)) {
  if (is.data.frame(XYZ)) {
    if (!all(c("X", "Y", "Z") %in% names(XYZ))) {
      stop("`XYZ` must contain columns named X, Y, and Z.")
    }
    XYZ <- as.matrix(XYZ[, c("X", "Y", "Z"), drop = FALSE])
  } else {
    XYZ <- as.matrix(XYZ)
  }

  if (!is.numeric(XYZ) || ncol(XYZ) != 3L) {
    stop("`XYZ` must be a numeric matrix or data.frame with 3 columns.")
  }

  if (!is.numeric(white) || length(white) != 3L) {
    stop("`white` must be a numeric vector of length 3.")
  }
  if (is.null(names(white))) {
    names(white) <- c("X", "Y", "Z")
  }
  if (!all(c("X", "Y", "Z") %in% names(white))) {
    stop("`white` must contain X, Y, and Z reference values.")
  }
  white <- white[c("X", "Y", "Z")]
  if (any(!is.finite(white)) || any(white <= 0)) {
    stop("Reference white values must be finite and positive.")
  }

  # Normalize XYZ by the reference white. XYZ and white must use
  # the same tristimulus scale (the default D65 white is on a 0-100 scale).
  xr <- XYZ[, 1L] / unname(white["X"])
  yr <- XYZ[, 2L] / unname(white["Y"])
  zr <- XYZ[, 3L] / unname(white["Z"])

  delta <- 6 / 29
  lab_f <- function(t) {
    out <- t / (3 * delta^2) + 4 / 29
    use_cuberoot <- !is.na(t) & t > delta^3
    out[use_cuberoot] <- t[use_cuberoot]^(1 / 3)
    out
  }

  fx <- lab_f(xr)
  fy <- lab_f(yr)
  fz <- lab_f(zr)

  data.frame(
    L = 116 * fy - 16,
    a = 500 * (fx - fy),
    b = 200 * (fy - fz)
  )
}
