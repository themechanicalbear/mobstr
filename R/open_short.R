#' @export
open_short <- function(data, tar_delta, put_call) {
  data %>%
    dplyr::filter(type == put_call) %>%
    dplyr::mutate(abs_delta = abs(delta - tar_delta)) %>%
    dplyr::group_by(quotedate) %>%
    dplyr::filter(m_dte == min(m_dte)) %>%
    dplyr::filter(abs_delta == min(abs_delta)) %>%
    dplyr::filter(dplyr::row_number() == 1) %>%
    dplyr::ungroup() %>%
    dplyr::select(quotedate, type, expiration, strike, delta, dte, mid)
}
