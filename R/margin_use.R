#' Calculate amount of margin in use
#'
#' @description{
#' Calculate the amount of margin in use each day during the study. Can be used
#' as a decision point on if new positions can be opened
#' }
#'
#' @param sy character string representing stock symbol for group and join later
#' @param st character string understood by lubridate ymd to represent open date of trade
#' @param en character string understood by lubridate ymd to represent closing date of trade
#' @param marg numeric of the margin at open for this position
#'
#' @importFrom lubridate ymd
#'
#' @return dataframe of dates when position was open including stock symbol and margin
#'
#' head(margin_use("SPY", "2018-01-01", "2018-02-16", 2135))
#' symbol entry_date  exit_date margin
#' SPY 2018-01-01 2018-02-16   2135
#' SPY 2018-01-02 2018-02-16   2135
#' SPY 2018-01-03 2018-02-16   2135
#' SPY 2018-01-04 2018-02-16   2135
#' SPY 2018-01-05 2018-02-16   2135
#' SPY 2018-01-06 2018-02-16   2135
#'
#' @export
#'
#' @examples
#' margin_use("SPY", "2018-01-01", "2018-02-16", 2135)
#'
#' Function ----
margin_use <- function(sy, st, en, marg) {
  data.frame(
    symbol = sy,
    entry_date = seq(ymd(st), ymd(en), by = "day"),
    exit_date = ymd(en),
    margin = marg
  )
}
