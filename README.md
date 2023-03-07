
<!-- README.md is generated from README.Rmd. Please edit that file -->

# streamFind

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The R package
[streamFind](https://github.com/ricardobachertdacunha/streamFind) is the
back-end framework for the streamFind project entitled “Flexible data
analysis and workflow designer to identify chemicals in the water
cycle”. The streamFind project is funded by the [Bundesministerium für
Bildung und Forschung (BMBF)](https://www.bmbf.de) and is a cooperation
between the [Institut für Energie- und Umwelttechnik e. V.
(IUTA)](https://www.iuta.de) and [Forschungszentrum Informatik
(FZI)](https://www.fzi.de/). The major focus of streamFind is data
processing for environmental and quality studies. The streamFind aims to
stimulate the use of advanced data analysis (e.g., non-target screening,
statistical analysis, etc.) in routine studies, promoting
standardization of data processing and structure and easing the
retrospective evaluation of data. The streamFind package can be used by
academics but also by technicians due to the comprehensive documentation
and well categorized set of integrated functions or modules (see
vignettes for more information).

<img src="man/figures/logo_group.png" width="100%" style="display: block; margin: auto;" />

## Installation

For installation of the
[streamFind](https://github.com/ricardobachertdacunha/streamFind) R
package, it is recommended to firstly ensure that the dependencies are
currently installed. Several existing R packages and external software
are used in streamFind for various processing steps. A major dependency
of streamFind is the [patRoon](https://github.com/rickhelmus/patRoon) R
package. The [patRoon](https://github.com/rickhelmus/patRoon) R package
combines several tools for basic and advanced data processing and can be
used interchangeably with streamFind.

### Install dependencies

[R](https://cran.r-project.org/) and
[RTools](https://cran.r-project.org/bin/windows/Rtools/) (the latter is
only recommended for Windows users). The
[handbook](https://rickhelmus.github.io/patRoon/handbook_bd/manual-installation.html#r-prerequisites)
of the [patRoon](https://github.com/rickhelmus/patRoon) R package offers
detailed installation instructions, including the required
[dependencies](https://rickhelmus.github.io/patRoon/handbook_bd/manual-installation.html#other-dependencies).

### Install streamFind

The [streamFind](https://github.com/ricardobachertdacunha/streamFind) R
package can be installed from the GitHub repository.

``` r
remotes::install_github("ricardobachertdacunha/streamFind", dependencies = TRUE)
```

The
[streamFindData](https://github.com/ricardobachertdacunha/streamFindData)
R package holds the data used in examples and other documentation assets
of the streamFind R package and can be installed from the GitHub
repository.

``` r
remotes::install_github("ricardobachertdacunha/streamFindData")
```

## Documentation

Documentation and usage articles can be found in
<https://ricardobachertdacunha.github.io/streamFind/>.
