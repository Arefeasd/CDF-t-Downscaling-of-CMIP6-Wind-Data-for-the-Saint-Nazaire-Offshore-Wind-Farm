This project applies the CDF-t statistical downscaling method to correct CMIP6 wind-speed projections for the Saint-Nazaire Offshore Wind Farm. ERA5 reanalysis is used as a proxy for local observations, and CMIP6 IPSL-CM6A-LR data provide historical (1980–1999) and future-boundary (2000–2014) inputs.

The workflow includes NetCDF processing in R, alignment of monthly series, CDF-t downscaling, and evaluation using Kolmogorov–Smirnov and Cramér–von Mises statistics. Results show a substantial reduction in model bias, with the downscaled series closely matching the observed distribution.

The repository contains R scripts, figures, and a detailed report documenting the full methodology.
