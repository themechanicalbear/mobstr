#' Truncate redshift table
#'
#' @description{
#' Truncate redshift table
#' }
#'
#' @importFrom RJDBC dbSendUpdate
#'
#' @param connection string representing RJDBC connection name
#' @param table_name string representing the table name in redshift
#'
#' @export
#'
# Truncate table on redshift
truncate_redshift <- function(connection, table_name) {
  RJDBC::dbSendUpdate(connection, paste0("TRUNCATE TABLE ", table_name, ";"))
}