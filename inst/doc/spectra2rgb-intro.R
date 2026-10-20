## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## -----------------------------------------------------------------------------
library(spectra2rgb)

wl  <- seq(400, 700, by = 10)
ref <- 0.1 + 0.6 * exp(-((wl - 550) / 60)^2)   # synthetic green peak

hs_to_xyz(wl, ref)
xyz_to_rgb(hs_to_xyz(wl, ref))

## -----------------------------------------------------------------------------
set.seed(1)
wl  <- seq(400, 700, by = 10)
mat <- matrix(runif(5 * length(wl), 0.1, 0.9), nrow = 5)
colnames(mat) <- as.character(wl)
df  <- as.data.frame(mat)

spectra_to_rgb_lab(df, id_col = paste0("leaf_", 1:5))

## -----------------------------------------------------------------------------
df2 <- df
df2[2, ] <- NA

# Silent zero-fill (default):
spectra_to_rgb(df2, na_action = "zero")

# Drop with warning:
suppressWarnings(spectra_to_rgb(df2, na_action = "drop"))

# Preserve NA:
spectra_to_rgb(df2, na_action = "keep")

