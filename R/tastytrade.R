#' \code{tastytrade} package
#'
#' tastrytrade R API
#'
#' See the README on
#'
#' @docType package
#' @name tastytrade
#' @importFrom dplyr filter group_by mutate ungroup distinct arrange select n
#' @import rlang
#' @importFrom RJDBC JDBC
#' @importFrom DBI dbConnect

NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1")  utils::globalVariables(c("."))

