#' Parse CMEP Records
#'
#' Parse an individual CMEP records.
#'
#' @param recs character vector with CMEP formatted records
#' @param unnest boolean; should the data values be unnested? if FALSE (the
#'   default) then they are returned in a list column with nested tables
#'
#' @return a [tibble][tibble::tibble-package] with the parsed records
#'
#' @export
#' @examples
#' f <- system.file("extdata", "cmep.dat", package = "cmep", mustWork = TRUE)
#' cmep_f <- read_cmep(f, parse = FALSE)
#' parse_cmep(cmep_f)
parse_cmep <- function(recs, unnest = FALSE) {
  if (!all(grepl(",", recs))) stop("CMEP records should be comma-separated strings", call. = FALSE)

  # split fields and determine record type
  rec_fields <- strsplit(recs, ",")
  rec_types <- vapply(rec_fields, function(x) x[1], character(1))

  if (!all(rec_types == "MEPMD01")) stop("Only CMEP record type 'MEPMD01' is currently supported.", call. = FALSE)
  cmep_parsed <- lapply(rec_fields, parse_MEPMD01)
  cmep_tbl <- do.call(rbind, cmep_parsed)

  if (unnest) {
    n <- cmep_tbl$count
    cmep_tbl_unnested <- cmep_tbl[rep(1:nrow(cmep_tbl), n), -15]
    cmep_tbl_unnested$end_time <- do.call(c, lapply(cmep_tbl$data, function(x) x$end_time))
    attr(cmep_tbl_unnested$end_time, "tzone") <- "UTC"   # re-set time zone
    cmep_tbl_unnested$quality_flag <- do.call(c, lapply(cmep_tbl$data, function(x) x$quality_flag))
    cmep_tbl_unnested$value <- do.call(c, lapply(cmep_tbl$data, function(x) x$value))
    cmep_tbl <- cmep_tbl_unnested
  }

  cmep_tbl
}

#' @importFrom tibble tibble
parse_MEPMD01 <- function(rec) {
  readings <- rec[-(1:14)]
  n_readings <- length(readings)

  reading_tbl <- tibble::tibble(
    end_time = as.POSIXct(readings[seq(1, n_readings, by = 3)],
                          tz = "UTC", format = "%Y%m%d%H%M"),             # TODO: handle tz
    quality_flag = readings[seq(2, n_readings, by = 3)],
    value = as.numeric(readings[seq(3, n_readings, by = 3)])
  )

  # parsed record with nested meter readings
  tibble::tibble(
    record_type = rec[1],
    record_version = rec[2],
    sender_id = rec[3],
    sender_customer_id = rec[4],
    receiver_id = rec[5],
    receiver_customer_id = rec[6],
    timestamp = as.POSIXct(rec[7], tz = "UTC", format = "%Y%m%d%H%M"),    # TODO: handle tz
    meter_id = rec[8],
    purpose = rec[9],
    commodity = rec[10],
    units = rec[11],
    calculation_constant = as.numeric(rec[12]),
    interval = rec[13],
    count = as.integer(rec[14]),
    data = list(reading_tbl)
  )
}
