#' Close single leg options trade
#'
#' @description{
#' Using function inputs from opened trades close each day until expiration
#' }
#'
#' @importFrom dplyr filter
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#'
#' @param df dataframe of opened options legs
#' @param entry_date date position was opened
#' @param exp date of expiration for position used to filter possible results
#' @param typ is this a put or a call option
#' @param stk option strike price
#' @param entry_mid mid price of the position when opened
#' @param entry_delta delta of the strike when position was opened
#' @param stk_price stock price when position was opened
#' @param direction was this a short or long position used to calc profit
#'
#' @return A dataframe of filtered closing option trades to be used in further
#' analysis. One row for each day a posistion was open open_date +1 through
#' expiration
#'
#' @export
#'

close_leg <- function(df, entry_date, exp, typ, stk,
                      entry_mid, entry_delta, stk_price, direction) {
  org <- "1970-01-01"
  tentm <- paste0(typ, "_entry_mid")
  textm <- paste0(typ, "_exit_mid")
  tpro <- paste0(typ, "_profit")
  tdel <- paste0(typ, "_entry_delta")

  df %>%
    filter(expiration == exp,
           quotedate > entry_date,
           strike == stk,
           type == typ) %>%
    mutate(direction = direction) %>%
    mutate(exit_mid = case_when(direction == "short" ~ mid,
                                TRUE ~ -mid),
           profit = entry_mid - exit_mid,
           entry_date = as.Date(entry_date, origin = org),
           entry_stock_price = stk_price,
           !!tentm := entry_mid,
           !!textm := exit_mid,
           !!tpro := profit,
           !!tdel := entry_delta) %>%
    select(symbol, quotedate, expiration, entry_date,
           entry_stock_price, !!tdel, !!tentm, !!textm, !!tpro)
}

