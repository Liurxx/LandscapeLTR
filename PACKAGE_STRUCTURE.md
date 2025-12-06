# LandscapeLTR Package Structure

## Overview

This R package provides visualization tools for LTR retrotransposon distribution landscapes. The package has been created from the `demo9.R` script and is fully documented in English.

## Package Contents

### Core Functions

1. **`plot_ltr_landscape()`** - Main function for creating LTR landscape plots
   - Location: `R/plot_ltr_landscape.R`
   - Documentation: `man/plot_ltr_landscape.Rd`
   - Exported: Yes

2. **`calc_stacking()`** - Internal function for calculating stacking positions
   - Location: `R/calc_stacking.R`
   - Documentation: `man/calc_stacking.Rd`
   - Exported: No (internal function)

3. **`generate_arrows()`** - Internal function for generating arrow markers
   - Location: `R/generate_arrows.R`
   - Documentation: `man/generate_arrows.Rd`
   - Exported: No (internal function)

### Data

1. **`ltr_example`** - Example dataset
   - Location: `data/ltr_example.rda`
   - Documentation: `R/ltr_example.R` and `man/ltr_example.Rd`
   - Format: Data frame with 15 rows

### Example Files

- **External data**: `inst/extdata/example_ltr_data.tsv`
- **Usage examples**: `inst/examples/example_usage.R`
- **Data creation script**: `data-raw/create_example_data.R`

### Documentation

- **README.md**: User guide with examples
- **INSTALL.md**: Installation instructions
- **man/**: Auto-generated roxygen2 documentation

## Key Features

1. **Balanced Layout**: Clades are automatically distributed above and below a central axis
2. **Automatic Stacking**: Overlapping elements are stacked to avoid visual overlap
3. **Strand Indicators**: Arrow markers show strand direction
4. **Flexible Input**: Accepts data frames or file paths
5. **Customizable**: Extensive options for plot customization

## Dependencies

- tidyverse (for data manipulation)
- ggplot2 (for plotting)
- ggsci (for color palettes)
- scales (for axis scaling)

## Usage Example

```r
library(LandscapeLTR)

# Load example data
data(ltr_example)

# Create plot
plot_ltr_landscape(ltr_example, target_region = c(66.0, 67.5))
```

## File Structure

```
LandscapeLTR/
├── R/                          # R source code
│   ├── plot_ltr_landscape.R    # Main plotting function
│   ├── calc_stacking.R         # Stacking algorithm
│   ├── generate_arrows.R       # Arrow generation
│   └── ltr_example.R           # Example data documentation
├── man/                        # Documentation (auto-generated)
│   ├── plot_ltr_landscape.Rd
│   ├── calc_stacking.Rd
│   ├── generate_arrows.Rd
│   └── ltr_example.Rd
├── data/                       # R data objects
│   └── ltr_example.rda
├── inst/
│   ├── extdata/                # External example files
│   │   ├── example_ltr_data.tsv
│   │   └── README
│   └── examples/               # Usage examples
│       └── example_usage.R
├── data-raw/                   # Data creation scripts
│   ├── create_example_data.R
│   └── example_data.tsv
├── DESCRIPTION                 # Package metadata
├── NAMESPACE                   # Exported functions
├── README.md                   # User guide
├── INSTALL.md                  # Installation guide
└── .Rbuildignore              # Build ignore patterns
```

## Building the Package

To build the package:

```r
devtools::build("path/to/LandscapeLTR")
```

To install:

```r
devtools::install("path/to/LandscapeLTR")
```

## Documentation

All functions are documented using roxygen2. To regenerate documentation:

```r
roxygen2::roxygenize("path/to/LandscapeLTR")
```

## Version

Current version: 1.0.0

