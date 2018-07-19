#' @export
open_short_put <- function(data, tar_delta_put) {
  short_put_opens <- data %>%
    dplyr::filter(type == "put") %>%
    dplyr::mutate(m_delta = abs(delta - tar_delta_put)) %>%
    dplyr::group_by(quotedate) %>%
    dplyr::filter(m_dte == min(m_dte)) %>%
    dplyr::filter(m_delta == min(m_delta)) %>%
    dplyr::filter(dplyr::row_number() == 1) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(strike_put = strike,
                  delta_put = delta,
                  mid_put = mid,
                  type_put = type) %>%
    dplyr::select(quotedate, type_put, expiration, strike_put, delta_put, dte, mid_put)
}


