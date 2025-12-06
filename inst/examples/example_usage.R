# Example usage of LandscapeLTR package
# This file demonstrates how to use the package

library(LandscapeLTR)

# Example 1: Using the built-in example data
data(ltr_example)
print(head(ltr_example))

# Create a plot with the example data
p1 <- plot_ltr_landscape(
  data = ltr_example,
  target_region = c(66.0, 67.5),
  title = "Example LTR Retrotransposon Landscape"
)
print(p1)

# Example 2: Using data from a file
# Uncomment the following lines to use your own data file:
# data_file <- system.file("extdata", "example_ltr_data.tsv", package = "LandscapeLTR")
# p2 <- plot_ltr_landscape(
#   data = data_file,
#   target_region = c(10.0, 11.0),
#   output_file = "example_plot.pdf"
# )

# Example 3: Customizing the plot
p3 <- plot_ltr_landscape(
  data = ltr_example,
  target_region = c(66.0, 67.5),
  min_width_mb = 0.05,
  track_height = 1.0,
  lane_buffer = 0.01,
  title = "Customized LTR Landscape",
  width = 14,
  height = 8
)
print(p3)

