#' @export
close_short_call_exp <- function(df, date, exp, c_strike, credit) {
  df %>%
    dplyr::filter(expiration == exp, quotedate == exp,
                  strike == c_strike & type == "call") %>%
    dplyr::group_by(quotedate) %>%
    dplyr::mutate(open_date = as.Date(date, origin = "1970-01-01"),
                  open_credit = credit,
                  debit = sum(mid),
                  profit = open_credit - debit) %>%
    dplyr::ungroup() %>%
    dplyr::select(symbol, quotedate, expiration, open_date,
                  open_credit, debit, profit) %>%
    dplyr::distinct()
}
