#' Calculate Stacking Positions for Overlapping Elements
#'
#' This internal function calculates lane assignments for overlapping
#' transposable elements to avoid visual overlap in the plot.
#'
#' @param df A data frame containing PlotStart and PlotEnd columns
#' @param buffer Numeric, minimum spacing between elements (default: 0.01)
#' @return A data frame with added 'lane' and 'total_lanes' columns
#'
#' @keywords internal
calc_stacking <- function(df, buffer = 0.01) {
  df <- df %>% dplyr::arrange(.data$PlotStart)
  n <- nrow(df)
  if(n == 0) return(df)
  
  lanes <- rep(1, n)
  lane_ends <- c(-Inf)
  
  for (i in 1:n) {
    start <- df$PlotStart[i]
    end <- df$PlotEnd[i]
    placed <- FALSE
    for (l in 1:length(lane_ends)) {
      if (start >= (lane_ends[l] + buffer)) {
        lanes[i] <- l
        lane_ends[l] <- end
        placed <- TRUE
        break
      }
    }
    if (!placed) {
      lane_ends <- c(lane_ends, end)
      lanes[i] <- length(lane_ends)
    }
  }
  df$lane <- lanes
  df$total_lanes <- length(lane_ends)
  return(df)
}

