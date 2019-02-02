#' Open short vertical spread
#'
#' @description{
#' Open Short Vertical Spread trade
#' }
#'
#' @param data dataframe of stock options
#' @param tar_delta integer of target delta for opening trade
#' @param put_call string either put or call
#' @param width numeric representing the width of the spread
#'
#' @export
#'
open_short_vert <- function(data, tar_delta, put_call, width) {
  tp <- paste0(put_call, "_type")
  s <- paste0(put_call, "_strike")
  ds <- paste0(put_call, "_delta_strike")
  oc <- paste0(put_call, "_open_credit")

  data %>%
    dplyr::filter(.data$type == put_call) %>%
    dplyr::mutate(abs_delta = abs(.data$delta_strike - tar_delta)) %>%
    dplyr::group_by(.data$quotedate) %>%
    dplyr::filter(.data$m_dte == min(.data$m_dte, na.rm = TRUE)) %>%
    dplyr::filter(.data$abs_delta == min(.data$abs_delta, na.rm = TRUE)) %>%
    dplyr::ungroup() %>%
    dplyr::collect() %>%
    dplyr::mutate(!!tp := .data$type,
                  !!s := .data$strike,
                  !!ds := .data$delta_strike,
                  !!oc := .data$mid,
                  quotedate = as.Date(.data$quotedate, origin = "1970-01-01"),
                  expiration = as.Date(.data$expiration, origin = "1970-01-01"))
}
