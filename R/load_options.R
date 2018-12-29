#' Load options data from local source
#'
#' @description{
#' Load options data from local source
#' }
#'
#' @param stock string representing the stock symbol
#' @param tar_dte int representing the DTE (Days to Expiration)
#'
#' @export
#'
load_options <- function(stock, tar_dte) {
  readRDS(paste0(here::here(), "/data/options/", stock, ".RDS")) %>%
    dplyr::mutate(m_dte = abs(.data$dte - tar_dte),
                  mid = (.data$bid + .data$ask) / 2) %>%
    dplyr::select(.data$symbol, .data$quotedate, .data$close, .data$type, .data$expiration,
                  .data$strike, .data$delta, .data$dte, .data$m_dte, .data$mid)
}