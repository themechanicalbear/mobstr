#' @export
close_short_exp <- function(df, date, exp, typ, stk, credit) {
  c <- paste0(typ, "_credit")
  d <- paste0(typ, "_debit")
  p <- paste0(typ, "_profit")

  df %>%
    dplyr::filter(expiration == exp, quotedate == exp,
                  strike == stk & type == typ) %>%
    dplyr::group_by(quotedate) %>%
    dplyr::mutate(open_credit = credit,
                  debit = sum(mid, na.rm = TRUE),
                  profit = open_credit - debit) %>%
    dplyr::ungroup() %>%
    dplyr::distinct() %>%
    dplyr::mutate(open_date = as.Date(date, origin = "1970-01-01"),
                  quotedate = as.Date(quotedate, origin = "1970-01-01"),
                  expiration = as.Date(expiration, origin = "1970-01-01"),
                  !!c := open_credit,
                  !!d := debit,
                  !!p := profit) %>%
    dplyr::select(symbol, quotedate, expiration, open_date,
                  !!c, !!d, !!p)
}