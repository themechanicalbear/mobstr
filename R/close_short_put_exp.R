#' @export
close_short_put_exp <- function(date, exp, p_strike, credit) {
  closes <- options %>%
    dplyr::filter(expiration == exp, quotedate == exp,
                  strike == p_strike & type == "put") %>%
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