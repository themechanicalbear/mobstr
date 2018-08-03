#' @export
close_short_daily <- function(df, date, exp, strk, credit, put_call) {
  open_credit <- paste0(put_call, "_open_credit")
  close_debit <- paste0(put_call, "_close_debit")
  profit <- paste0(put_call, "_profit")

  df %>%
    dplyr::filter(expiration == exp,
                  quotedate > date,
                  strike == strk,
                  type == put_call) %>%
    dplyr::group_by(quotedate) %>%
    dplyr::mutate(open_date = date,
                  open_credit := credit,
                  close_debit := mid,
                  profit := credit - mid) %>%
    dplyr::ungroup() %>%
    dplyr::collect() %>%
    dplyr::mutate(open_date = as.Date(open_date, origin = "1970-01-01"),
                  expiration = as.Date(expiration, origin = "1970-01-01"),
                  quotedate = as.Date(quotedate, origin = "1970-01-01"),
                  !!open_credit := open_credit,
                  !!close_debit := close_debit,
                  !!profit := profit) %>%
    dplyr::select(symbol, quotedate, expiration, open_date,
                  !!open_credit, !!close_debit, !!profit)
}
