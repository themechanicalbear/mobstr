#' @export
dte_exit <- function(df, exit_dte, exp) {
  dt <- as.Date(exp, format = "%Y-%m-%d")
  df %>%
    dplyr::filter(expiration == dt) %>%
    dplyr::mutate(mid_dte = abs(dte - exit_dte)) %>%
    dplyr::filter(mid_dte == min(mid_dte, na.rm = TRUE)) %>%
    dplyr::distinct(quotedate, close_price, expiration, dte) %>%
    dplyr::collect()
}
