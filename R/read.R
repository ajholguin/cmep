#' Read CMEP File
#'
#' Read and parse CMEP file
#'
#' @param file path to file
#' @param ... passed to \code{\link[readr]{read_lines}}
#'
#' @export
#' @examples
#' f <- system.file("extdata", "cmep.dat", package = "cmep", mustWork = TRUE)
#' read_cmep(f)
read_cmep <- function(file, ...) {
  readr::read_lines(file, ...)
}
