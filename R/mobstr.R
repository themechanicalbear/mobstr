#' \code{mobstr} package
#'
#' mobstr R API
#'
#' See the README on
#'
#' @docType package
#' @name mobstr
#' @importFrom dplyr filter group_by mutate ungroup distinct arrange select n
#' @import rlang
#' @importFrom RJDBC JDBC
#' @importFrom DBI dbConnect

NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c("expiration", "exit_mid", "profit", "symbol",
                           "entry_stock_price", "type", "delta", "dte",
                           "quotedate", "m_dte", "abs_delta", "strike",
                           "mid", "bid", "ask"))
}

