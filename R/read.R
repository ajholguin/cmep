#' Read CMEP File
#'
#' Read and parse CMEP file. These functions are mostly just simple wrappers
#' around the more generic \code{readr} functions. The main enhancement is that
#' they will parse an irregularly sized CMEP file and format the data as a
#' regular table (data frame). \code{read_cmep_chunked} can be used to process
#' files that may be too large to fit in memory.
#'
#' @param ... passed to \code{\link[readr]{read_lines}} or
#'   \code{\link[readr]{read_lines_chunked}}
#' @param parse boolean; should the records be parsed?
#'
#' @rdname read_cmep
#' @export
#' @examples
#' f <- system.file("extdata", "cmep.dat", package = "cmep", mustWork = TRUE)
#' read_cmep(f)
read_cmep <- function(..., parse = TRUE) {
  x <- readr::read_lines(...)
  if (parse) x <- parse_cmep(x)
  x
}

#' @rdname read_cmep
#' @export
#' @examples
#' f <- system.file("extdata", "cmep.dat", package = "cmep", mustWork = TRUE)
#' cb_f <- function(x, pos) print(pos)
#' read_cmep_chunked(f, callback = cb_f, chunk_size = 2)
read_cmep_chunked <- function(..., parse = TRUE) {
  dots <- list(...)
  if (parse) {
    # call `parse_cmep` on x before the normal callback function
    cbf <- dots$callback
    dots$callback <- function(x, pos) {
      x <- parse_cmep(x)
      do.call(cbf, list(x, pos))
    }
  }
  do.call(readr::read_lines_chunked, dots)
}
