#' @export
load_options <- function(stock, tar_dte) {
  readRDS(paste0(here::here(), "/data/options/", stock, ".RDS")) %>%
    dplyr::mutate(m_dte = abs(dte - tar_dte),
                  mid = (bid + ask) / 2) %>%
    dplyr::select(symbol, quotedate, close, type, expiration, strike, delta, dte, m_dte, mid)
}