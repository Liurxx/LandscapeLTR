# Installation Guide for LandscapeLTR

## Prerequisites

Before installing LandscapeLTR, make sure you have R (>= 4.0.0) installed.

## Required R Packages

The following packages are required and will be installed automatically if not present:

- **tidyverse**: Data manipulation and visualization
- **ggplot2**: Plotting (included in tidyverse)
- **ggsci**: Scientific color palettes
- **scales**: Scale functions for graphics

## Installation Steps

### Option 1: Install from Local Directory

```r
# Install devtools if not already installed
if (!require("devtools")) {
  install.packages("devtools")
}

# Install LandscapeLTR from local directory
devtools::install("path/to/LandscapeLTR")
```

### Option 2: Build and Install

```r
# Build the package
system("R CMD build LandscapeLTR")

# Install the built package
install.packages("LandscapeLTR_1.0.0.tar.gz", repos = NULL, type = "source")
```

### Option 3: Load for Development

If you want to work on the package source code:

```r
# Load the package in development mode
devtools::load_all("path/to/LandscapeLTR")
```

## Verification

After installation, verify that the package works:

```r
library(LandscapeLTR)
data(ltr_example)
plot_ltr_landscape(ltr_example, target_region = c(66.0, 67.5))
```

## Troubleshooting

### Missing Dependencies

If you encounter errors about missing packages, install them manually:

```r
install.packages(c("tidyverse", "ggplot2", "ggsci", "scales"))
```

### Documentation Issues

If documentation is not available, regenerate it:

```r
devtools::document("path/to/LandscapeLTR")
```

## Building Documentation

To build the package documentation:

```r
devtools::document("path/to/LandscapeLTR")
```

## Package Structure

```
LandscapeLTR/
├── R/                    # R source code
│   ├── plot_ltr_landscape.R
│   ├── calc_stacking.R
│   ├── generate_arrows.R
│   └── ltr_example.R
├── man/                  # Documentation (auto-generated)
├── data/                 # Example datasets
├── inst/
│   ├── extdata/          # External example data files
│   └── examples/         # Usage examples
├── data-raw/             # Scripts for creating data
├── DESCRIPTION           # Package metadata
├── NAMESPACE             # Exported functions
└── README.md             # User guide
```

