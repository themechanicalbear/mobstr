#' @export
# Truncate table on redshift
truncate_redshift <- function(connection, table_name) {
  RJDBC::dbSendUpdate(connection, paste0("TRUNCATE TABLE ", table_name, ";"))
}