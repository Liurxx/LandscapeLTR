#' Generate Arrow Markers for Strand Direction
#'
#' This internal function generates arrow markers to indicate strand direction
#' for transposable elements in the plot.
#'
#' @param xmin Numeric, minimum x coordinate
#' @param xmax Numeric, maximum x coordinate
#' @param y Numeric, y coordinate
#' @param strand Character, strand direction ("+" or "-")
#' @param count Integer, number of arrows to generate (default: 4)
#' @return A data frame with x, y, and label columns
#'
#' @keywords internal
generate_arrows <- function(xmin, xmax, y, strand, count = 4) {
  margin <- (xmax - xmin) * 0.15
  x_seq <- seq(xmin + margin, xmax - margin, length.out = 4) 
  data.frame(x = x_seq, y = y, label = ifelse(strand == "+", "\u25B6", "\u25C0"))
}

