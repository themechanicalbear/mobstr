#' @export
close_short_daily <- function(df, date, exp, strike, credit, put_call) {
  closes <- df %>%
    dplyr::filter(expiration == exp, quotedate > date,
                  strike == strike & type == put_call) %>%
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