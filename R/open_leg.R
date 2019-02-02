#' TODO resolve method to use max strike for shorts and min strike for calls

#' Open single leg options trade
#'
#' @description{
#' Using function inputs for options type, direction, target delta, and buffer
#' open a single option leg trade
#' }
#'
#' @import dplyr
#' @importFrom rlang .data
#'
#' @param conn AWS Athena connection
#' @param stock character string of stock symbol
#' @param put_call is this a put or call option we are opening?
#' @param direction credit or debit (short or long trade)
#' @param tar_delta target delta for the option
#' @param tar_dte target number of days to expiration at entry
#'
#' @export
#'
#' @return A dataframe of filtered opening option trades to be used in further
#' analysis.
#'

open_leg <- function(conn, stock, put_call, direction, tar_delta, tar_dte) {
  tp  <- paste0(put_call, "_type")
  s   <- paste0(put_call, "_strike")
  ds  <- paste0(put_call, "_delta")
  om  <- paste0(put_call, "_open_", direction)

  conn %>%
    dplyr::tbl(stock) %>%
    dplyr::filter(type == put_call) %>%
    dplyr::mutate(abs_delta = abs(delta - tar_delta),
                  m_dte = abs(dte - tar_dte)) %>%
    dplyr::group_by(quotedate) %>%
    dplyr::filter(m_dte == min(m_dte, na.rm = TRUE)) %>%
    dplyr::filter(abs_delta == min(abs_delta, na.rm = TRUE)) %>%
    dplyr::ungroup() %>%
    dplyr::collect() %>%
    dplyr::mutate(!!tp := type,
                  !!s := strike,
                  !!ds := delta,
                  !!om := mid)
}
