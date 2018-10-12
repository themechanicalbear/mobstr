#' @export
close_short_exp <- function(df, date, exp, typ, stk, credit, dlt, stk_price) {
  o_credit <- paste0(typ, "_credit")
  o_debit <- paste0(typ, "_debit")
  prof <- paste0(typ, "_profit")
  o_delta <- paste0(typ, "_delta")

  df %>%
    filter(expiration == exp,
           quotedate == exp,
           strike == stk,
           type == typ) %>%
    group_by(quotedate) %>%
    mutate(debit = case_when(
      sum(mid, na.rm = TRUE) == 0.005 ~ 0.00,
      TRUE ~ sum(mid, na.rm = TRUE)),
      profit = credit - debit) %>%
    ungroup() %>%
    distinct() %>%
    mutate(open_date = as.Date(date, origin = "1970-01-01"),
           quotedate = as.Date(quotedate, origin = "1970-01-01"),
           expiration = as.Date(expiration, origin = "1970-01-01"),
           open_stock_price = stk_price,
           !!o_credit := credit,
           !!o_debit := debit,
           !!prof := profit,
           !!o_delta := dlt) %>%
    select(symbol, quotedate, expiration, open_date, open_stock_price,
           !!o_delta, !!o_credit, !!o_debit, !!prof)
}