#' @export
close_short_put_exp <- function(df, date, exp, p_strike, credit) {
  df %>%
    dplyr::filter(expiration == exp, quotedate == exp,
                  strike == p_strike & type == "put") %>%
    dplyr::group_by(quotedate) %>%
    dplyr::mutate(open_credit = credit,
                  debit = sum(mid, na.rm = TRUE),
                  profit = open_credit - debit) %>%
    dplyr::ungroup() %>%
    dplyr::distinct() %>%
    dplyr::mutate(open_date = as.Date(date, origin = "1970-01-01")) %>%
    dplyr::select(symbol, quotedate, expiration, open_date,
                  open_credit, debit, profit)
}