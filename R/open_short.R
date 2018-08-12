#' @export
open_short <- function(data, tar_delta, put_call) {
  tp <- paste0(put_call, "_type")
  s <- paste0(put_call, "_strike")
  ds <- paste0(put_call, "_delta_strike")
  oc <- paste0(put_call, "_open_credit")

  data %>%
    dplyr::filter(type == put_call) %>%
    dplyr::mutate(abs_delta = abs(delta_strike - tar_delta)) %>%
    dplyr::group_by(quotedate) %>%
    dplyr::filter(m_dte == min(m_dte, na.rm = TRUE)) %>%
    dplyr::filter(abs_delta == min(abs_delta, na.rm = TRUE)) %>%
    dplyr::ungroup() %>%
    dplyr::collect() %>%
    dplyr::mutate(!!tp := type,
                  !!s := strike,
                  !!ds := delta_strike,
                  !!oc := mid,
                  quotedate = as.Date(quotedate, origin = "1970-01-01"),
                  expiration = as.Date(expiration, origin = "1970-01-01")) #%>%
    #dplyr::select(symbol, quotedate, !!tp, expiration, !!s, !!ds, dte, !!oc)
}

