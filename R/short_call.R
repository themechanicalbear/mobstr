#' @export
open_short_call <- function(data, stock, tar_delta_call) {
  short_call_opens <- data %>%
    dplyr::filter(type == "call") %>%
    dplyr::mutate(m_delta = abs(delta - tar_delta_call)) %>%
    dplyr::group_by(quotedate) %>%
    dplyr::filter(m_dte == min(m_dte)) %>%
    dplyr::filter(m_delta == min(m_delta)) %>%
    dplyr::filter(dplyr::row_number() == 1) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(strike_call = strike,
                  delta_call = delta,
                  mid_call = mid,
                  type_call = type) %>%
    dplyr::select(quotedate, type_call, expiration, strike_call, delta_call, dte, mid_call)

  return(short_call_opens)
}
