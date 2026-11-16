
# spectra2rgb 0.1.1

* `xyz_to_lab()` now converts CIE XYZ tristimulus values directly to CIELAB
  using the specified reference white, without intermediate sRGB conversion,
  gamut clipping, or 8-bit quantization.

* `spectra_to_rgb_lab()` now calculates CIELAB directly from unquantized
  XYZ values, independently of the sRGB output.

* Updated function documentation and added tests for direct XYZ-to-CIELAB
  conversion, matrix inputs, and coordinate-specific missing-value handling.
