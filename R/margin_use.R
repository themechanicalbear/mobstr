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
#' @export
#'
margin_use <- function(sy, st, en, marg) {
  data.frame(
    symbol = sy,
    entry_date = seq(lubridate::ymd(st), lubridate::ymd(en), by = "day"),
    exit_date = lubridate::ymd(en),
    margin = marg
  )
}
