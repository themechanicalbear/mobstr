#' Load data to Amazon Athena
#'
#' @description{
#' Make an ODBC connection to an Amazon Athena using settings from
#' the environment variables loaded with .RProfile
#' }
#'
#' @importFrom DBI dbConnect
#'
#' @param conn odbc conn created with mobstr::athena_connect
#' @param database string representing the database name in AWS Athena
#' @param stock string representing the stock symbol to be uploaded to athena
#'
#' @export
#'
#'

# TODO change the data types for each column

athena_load <- function(conn, database, stock) {
  #---sql  create table statement in Athena
  DBI::dbExecute(conn, paste0("CREATE EXTERNAL TABLE IF NOT EXISTS ", database, ".", stock, " (
`symbol` string,
`quotedate` date,
`calliv` double,
`putiv` double,
`meaniv` double,
`callvol` double,
`putvol` double,
`calloi` double,
`putoi` double,
`open` double,
`high` double,
`low` double,
`close` double,
`volume` double,
`type` string,
`expiration` date,
`strike` double,
`last` double,
`bid` double,
`ask` double,
`option_volume` double,
`open_interest` double,
`iv_strike` double,
`delta` double,
`gamma` double,
`theta` double,
`vega` double,
`dte` double,
`exp_type` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
    'serialization.format' = ',',
    'field.delim' = ',' )
LOCATION 's3://mechanicalbear-athena/", stock, "/'
TBLPROPERTIES ('has_encrypted_data'='false', 'skip.header.line.count'='1');"))
}
