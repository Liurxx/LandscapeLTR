#' Plot LTR Retrotransposon Distribution Landscape
#'
#' This function creates a visualization of LTR retrotransposon distribution
#' along a genomic region with a centered axis layout. Clades are balanced
#' above and below the central axis for optimal visualization.
#'
#' @param data A data frame or path to a TSV file containing LTR data.
#'   Required columns: TE (format: "Chr:Start-End"), Clade, Strand
#' @param target_region Numeric vector of length 2, specifying the genomic
#'   region to plot in Mb (default: NULL, will use data range)
#' @param min_width_mb Numeric, minimum width for elements in Mb (default: 0.04)
#' @param track_height Numeric, height of each track (default: 0.85)
#' @param lane_buffer Numeric, spacing between lanes (default: 0.005)
#' @param output_file Character, path to save the plot. If NULL, plot is
#'   returned without saving (default: NULL)
#' @param width Numeric, plot width in inches (default: 12)
#' @param height Numeric, plot height in inches (default: 7)
#' @param dpi Numeric, resolution for PNG output (default: 300)
#' @param title Character, plot title (default: "Landscape of LTR Retrotransposons (Centered Axis)")
#' @param return_plot Logical, whether to return the ggplot object (default: TRUE)
#'
#' @return A ggplot object if return_plot is TRUE, otherwise NULL
#'
#' @examples
#' \dontrun{
#' # Using example data
#' data(ltr_example)
#' plot_ltr_landscape(ltr_example, target_region = c(66.5, 67.5))
#'
#' # From file
#' plot_ltr_landscape("path/to/data.tsv", target_region = c(66.5, 67.5))
#' }
#'
#' @export
plot_ltr_landscape <- function(data,
                                target_region = NULL,
                                min_width_mb = 0.04,
                                track_height = 0.85,
                                lane_buffer = 0.005,
                                output_file = NULL,
                                width = 12,
                                height = 7,
                                dpi = 300,
                                title = "Landscape of LTR Retrotransposons (Centered Axis)",
                                return_plot = TRUE) {
  
  # Load required packages
  if (!requireNamespace("tidyverse", quietly = TRUE)) {
    stop("Package 'tidyverse' is required but not installed.")
  }
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required but not installed.")
  }
  if (!requireNamespace("ggsci", quietly = TRUE)) {
    stop("Package 'ggsci' is required but not installed.")
  }
  if (!requireNamespace("scales", quietly = TRUE)) {
    stop("Package 'scales' is required but not installed.")
  }
  
  # Read data if file path provided
  if (is.character(data) && length(data) == 1 && file.exists(data)) {
    cat("Reading data from file...\n")
    te_raw <- readr::read_tsv(data, col_types = readr::cols(), show_col_types = FALSE)
  } else if (is.data.frame(data)) {
    te_raw <- data
  } else {
    stop("'data' must be either a data frame or a valid file path to a TSV file.")
  }
  
  # Check required columns
  required_cols <- c("TE", "Clade", "Strand")
  missing_cols <- setdiff(required_cols, colnames(te_raw))
  if (length(missing_cols) > 0) {
    stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
  }
  
  # Data cleaning
  cat("Processing data...\n")
  te_clean <- te_raw %>%
    tidyr::separate(.data$TE, into = c("Chr", "Range"), sep = ":", remove = FALSE) %>%
    tidyr::separate(.data$Range, into = c("Start", "End"), sep = "-", convert = TRUE) %>%
    dplyr::mutate(
      StartMb  = .data$Start / 1e6,
      EndMb    = .data$End   / 1e6,
      MidMb    = (.data$StartMb + .data$EndMb) / 2,
      Clade    = factor(.data$Clade)
    )
  
  # Determine target region
  data_range <- range(c(te_clean$StartMb, te_clean$EndMb), na.rm = TRUE)
  if (is.null(target_region)) {
    target_region <- c(floor(data_range[1]), floor(data_range[1]) + 1.0)
    cat(sprintf("Using default target region: %.2f - %.2f Mb\n", 
                target_region[1], target_region[2]))
  } else if (target_region[1] < data_range[1] || target_region[2] > data_range[2]) {
    warning("Target region outside data range, adjusting...")
    target_region <- c(floor(data_range[1]), floor(data_range[1]) + 1.0)
  }
  
  # Filter and adjust widths
  te_plot <- te_clean %>%
    dplyr::filter(.data$EndMb >= target_region[1], .data$StartMb <= target_region[2]) %>%
    dplyr::mutate(
      VisStart = pmax(.data$StartMb, target_region[1]),
      VisEnd   = pmin(.data$EndMb, target_region[2]),
      VisMid   = (.data$VisStart + .data$VisEnd) / 2,
      VisLen   = .data$VisEnd - .data$VisStart,
      FinalLen = pmax(.data$VisLen, min_width_mb), 
      PlotStart = .data$VisMid - .data$FinalLen / 2,
      PlotEnd   = .data$VisMid + .data$FinalLen / 2
    )
  
  if (nrow(te_plot) == 0) {
    stop("No data found in the specified target region.")
  }
  
  # Calculate stacking
  cat("Calculating stacking positions...\n")
  te_stacked <- te_plot %>%
    dplyr::group_by(.data$Clade) %>%
    dplyr::group_modify(~ calc_stacking(.x, buffer = lane_buffer)) %>%
    dplyr::ungroup()
  
  # Calculate balanced layout coordinates
  cat("Calculating balanced layout coordinates...\n")
  all_clades <- sort(unique(te_stacked$Clade))
  n_clades <- length(all_clades)
  
  # Split clades: half above, half below
  mid_point <- ceiling(n_clades / 2)
  top_clades <- all_clades[1:mid_point]
  bottom_clades <- all_clades[(mid_point + 1):n_clades]
  
  # Assign Y-axis indices
  y_centers <- numeric()
  if(length(top_clades) > 0) {
    y_centers[as.character(top_clades)] <- seq_along(top_clades)
  }
  if(length(bottom_clades) > 0) {
    y_centers[as.character(bottom_clades)] <- -seq_along(bottom_clades)
  }
  
  te_final <- te_stacked %>%
    dplyr::mutate(
      base_y = y_centers[as.character(.data$Clade)],
      row_height = (track_height / .data$total_lanes) * 0.45,
      offset = (.data$lane - 1) - (.data$total_lanes - 1) / 2,
      ymin = .data$base_y + .data$offset * (track_height / .data$total_lanes) - .data$row_height/2,
      ymax = .data$base_y + .data$offset * (track_height / .data$total_lanes) + .data$row_height/2,
      arrow_y = (.data$ymin + .data$ymax) / 2
    )
  
  # Generate arrow data
  arrow_data <- te_final %>%
    dplyr::rowwise() %>%
    dplyr::do(generate_arrows(.$PlotStart, .$PlotEnd, .$arrow_y, .$Strand, count = 4)) %>%
    dplyr::ungroup()
  
  # Create plot
  cat("Generating plot...\n")
  p <- ggplot2::ggplot() +
    # Central axis (chromosome backbone)
    ggplot2::geom_hline(yintercept = 0, color = "#222222", linewidth = 1.5) +
    
    # Vertical lines
    ggplot2::geom_segment(data = te_final,
                 ggplot2::aes(x = .data$MidMb, xend = .data$MidMb, 
                     y = 0, yend = ifelse(.data$base_y > 0, .data$ymin, .data$ymax)),
                 color = "grey60", linetype = "dotted", linewidth = 0.4) +
    
    # Rectangles
    ggplot2::geom_rect(data = te_final,
              ggplot2::aes(xmin = .data$PlotStart, xmax = .data$PlotEnd, 
                  ymin = .data$ymin, ymax = .data$ymax, 
                  fill = .data$Clade), 
              color = "black", linewidth = 0.1, alpha = 0.95) +
    
    # Arrow markers
    ggplot2::geom_text(data = arrow_data,
              ggplot2::aes(x = .data$x, y = .data$y, label = .data$label),
              color = "white",
              size = 2.2,
              family = "sans") +
    
    # Scales and theme
    ggsci::scale_fill_npg() +
    ggplot2::scale_x_continuous(name = "Genomic Position (Mb)", 
                       breaks = scales::pretty_breaks(n = 5)) +
    ggplot2::scale_y_continuous(
      name = "TE Lineage Distribution",
      breaks = sort(unique(te_final$base_y)),
      labels = names(sort(y_centers))
    ) +
    
    ggplot2::theme_minimal(base_family = "sans", base_size = 15) +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      axis.line.x = ggplot2::element_line(color = "black", linewidth = 0.5),
      axis.text.y = ggplot2::element_text(face = "italic", size = 12),
      axis.title = ggplot2::element_text(face = "bold"),
      legend.position = "right"
    ) +
    ggplot2::labs(
      title = title,
      subtitle = sprintf("Region: %.2f - %.2f Mb", target_region[1], target_region[2])
    )
  
  # Save plot if output file specified
  if (!is.null(output_file)) {
    cat(sprintf("Saving plot to %s...\n", output_file))
    ext <- tools::file_ext(output_file)
    if (ext == "pdf") {
      ggplot2::ggsave(output_file, p, width = width, height = height, 
                     device = grDevices::cairo_pdf)
    } else if (ext %in% c("png", "jpg", "jpeg")) {
      ggplot2::ggsave(output_file, p, width = width, height = height, 
                     dpi = dpi, bg = "white")
    } else {
      ggplot2::ggsave(output_file, p, width = width, height = height)
    }
  }
  
  if (return_plot) {
    return(p)
  } else {
    return(invisible(NULL))
  }
}

