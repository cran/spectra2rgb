#' Convert a data frame of spectra to sRGB and CIELAB
#'
#' @inheritParams spectra_to_rgb
#' @param white Reference white point used for both the XYZ-to-sRGB and
#'   direct XYZ-to-CIELAB conversions. XYZ values and the white point
#'   use the same tristimulus scale.
#' @details RGB and CIELAB coordinates are calculated independently from
#'   the same unquantized CIE XYZ tristimulus values. The CIELAB calculation
#'   does not pass through 8-bit sRGB values.
#'
#' @return A data.frame with columns \code{Sample_ID}, \code{R}, \code{G},
#'   \code{B}, \code{hex}, \code{L}, \code{a}, \code{b}.
#'
#' @export
spectra_to_rgb_lab <- function(df, id_col = NULL,
                               na_action = c("zero", "drop", "keep"),
                               white = c(X = 95.047, Y = 100, Z = 108.883)) {
  na_action <- match.arg(na_action)
  prep <- .prep_spectra(df, id_col, na_action)
  xyz  <- hs_to_xyz(prep$wavelengths, prep$reflectance)
  rgb  <- xyz_to_rgb(xyz, white = white)
  lab  <- xyz_to_lab(xyz, white = white)
  if (na_action == "keep") {
    rgb[prep$na_rows, c("R", "G", "B", "hex")] <- NA
    lab[prep$na_rows, c("L", "a", "b")] <- NA
  }
  cbind(data.frame(Sample_ID = prep$ids, stringsAsFactors = FALSE),
        rgb, lab)
}
