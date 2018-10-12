# TODO resolve method to use max strike for shorts and min strike for calls

#' Open single leg options trade
#'
#' @description{
#' Using function inputs for options type, direction, target delta, and buffer
#' open a single option leg trade
#' }
#'
#' @import dplyr
#'
#' @param data table from redshift not yet collected
#'
#' @param put_call is this a put or call option we are opening?
#' @param direction credit or debit (short or long trade)
#' @param tar_delta target delta for the option
#' @param tar_buffer percent the strike should be away from ATM
#'
#' @export
#'
#'
#' @return A dataframe of filtered opening option trades to be used in further
#' analysis.
#'
#' @examples
#' open_leg(data = options, put_call = "put", direction = "credit",
#'          tar_delta = -0.16, tar_buffer = 0.10)
#'
#'
# Function ----
open_leg <- function(data, put_call, direction, tar_delta, tar_buffer) {
  org <- "1970-01-01"
  tp  <- paste0(put_call, "_type")
  s   <- paste0(put_call, "_strike")
  ds  <- paste0(put_call, "_delta_strike")
  om  <- paste0(put_call, "_open_", direction)

  if (!is.na(tar_delta)) {
    trades <- data %>%
      filter(type == put_call) %>%
      mutate(abs_delta = abs(delta_strike - tar_delta)) %>%
      group_by(quotedate) %>%
      filter(m_dte == min(m_dte, na.rm = TRUE)) %>%
      filter(abs_delta == min(abs_delta, na.rm = TRUE)) %>%
      ungroup() %>%
      collect() %>%
      mutate(!!tp := type,
             !!s := strike,
             !!ds := delta_strike,
             !!om := mid,
             quotedate = as.Date(quotedate, origin = org),
             expiration = as.Date(expiration, origin = org))
  }

  if (!is.na(tar_buffer)) {
    trades <- data %>%
      filter(type == put_call) %>%
      filter(strike < close_price) %>%
      group_by(quotedate) %>%
      filter(m_dte == min(m_dte, na.rm = TRUE)) %>%
      mutate(strike_buff = (close_price - strike) / close_price) %>%
      filter(strike_buff >= tar_buffer) %>%
      filter(strike == max(strike, na.rm = TRUE)) %>%
      ungroup() %>%
      collect() %>%
      mutate(!!tp := type,
             !!s := strike,
             !!ds := delta_strike,
             !!om := mid,
             quotedate = as.Date(quotedate, origin = org),
             expiration = as.Date(expiration, origin = org))
  }
  trades
}
