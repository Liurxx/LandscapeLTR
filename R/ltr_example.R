#' Example LTR Retrotransposon Data
#'
#' A small example dataset containing LTR retrotransposon annotations
#' for demonstration purposes.
#'
#' @format A data frame with 15 rows and 7 variables:
#' \describe{
#'   \item{TE}{Character, transposable element identifier in format "Chr:Start-End"}
#'   \item{Order}{Character, TE order (all "LTR" in this example)}
#'   \item{Superfamily}{Character, TE superfamily (Copia or Gypsy)}
#'   \item{Clade}{Character, TE clade classification}
#'   \item{Complete}{Character, whether the element is complete ("yes" or "no")}
#'   \item{Strand}{Character, strand orientation ("+" or "-")}
#'   \item{Domains}{Character, protein domains present in the element}
#' }
#'
#' @source Simulated data for package demonstration
#'
#' @examples
#' data(ltr_example)
#' head(ltr_example)
#' plot_ltr_landscape(ltr_example, target_region = c(66.0, 67.5))
#'
"ltr_example"

