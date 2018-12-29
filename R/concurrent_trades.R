#' Calculate number of concurrent trades for each day
#'
#' @description{
#' Number of trades open on any given day can be used to calculate when multiple
#' entries would cause more capital allocated to a strategy by symbol than desired
#' }
#'
#' @param sy character string representing stock symbol for group and join later
#' @param st character string understood by lubridate ymd to represent open date of trade
#' @param en character string understood by lubridate ymd to represent closing date of trade
#'
#' @importFrom lubridate ymd
#'
#' @return dataframe of dates when position was open including stock symbol
#'
#' @export
#'
concurrent_trades <- function(sy, st, en) {
  data.frame(
    symbol = sy,
    quote_date = seq(ymd(st), ymd(en), by = "day"),
    exit_date = ymd(en)
  )
}
