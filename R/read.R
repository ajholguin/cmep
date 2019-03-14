#' Read CMEP File
#'
#' Read and parse CMEP file. Currently, the functions are just simple wrappers
#' around the more generic \code{readr} functions.
#'
#' @param ... passed to \code{\link[readr]{read_lines}}
#' @param parse boolean; should the records be parsed?
#'
#' @export
#' @examples
#' f <- system.file("extdata", "cmep.dat", package = "cmep", mustWork = TRUE)
#' read_cmep(f)
read_cmep <- function(..., parse = TRUE) {
  x <- readr::read_lines(...)
  if (parse) x <- parse_cmep(x)
  x
}
