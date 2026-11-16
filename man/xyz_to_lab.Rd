
\name{xyz_to_lab}
\alias{xyz_to_lab}
\title{Convert CIE XYZ directly to CIELAB}
\usage{
xyz_to_lab(XYZ, white = c(X = 95.047, Y = 100, Z = 108.883))
}
\arguments{
\item{XYZ}{A data frame with columns \code{X}, \code{Y}, and \code{Z}, or a numeric matrix with three columns. XYZ values and \code{white} must use the same scale.}

\item{white}{Reference white point, expressed on the same scale as \code{XYZ}. Must contain three positive, finite values named \code{X}, \code{Y}, and \code{Z}. Defaults to D65 (\code{c(X = 95.047, Y = 100, Z = 108.883)}).}
}
\value{
A data frame with numeric columns \code{L}, \code{a}, and \code{b}.
}
\description{
Converts CIE XYZ tristimulus values directly to CIELAB coordinates using the specified reference white. This calculation does not pass through sRGB and therefore avoids sRGB gamut clipping, gamma encoding, and 8-bit quantization.
}
\details{
The standard CIELAB piecewise function is applied to the normalized tristimulus values \eqn{X/X_n}, \eqn{Y/Y_n}, and \eqn{Z/Z_n}, where \eqn{X_n}, \eqn{Y_n}, and \eqn{Z_n} are the tristimulus values of the reference white.

Missing XYZ values propagate to the output coordinates that depend on them. Specifically, missing X affects \eqn{a^*}, missing Y affects all three coordinates, and missing Z affects \eqn{b^*}.
}
