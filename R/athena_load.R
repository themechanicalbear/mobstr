#' Load data to Amazon Athena
#'
#' @description{
#' Make an ODBC connection to an Amazon Athena using settings from
#' the environment variables loaded with .RProfile
#' }
#'
#' @importFrom DBI dbExecute
#'
#' @param conn odbc conn created with mobstr::athena_connect
#' @param database string representing the database name in AWS Athena
#' @param s3_bucket string representing the AWS S3 bucket name
#' @param name string representing the name you want to assign to the table
#' @param df dataframe name
#'
#'
#' @export
#'
#'

athena_load <- function(conn, database, s3_bucket, name, df) {
  table_vars <- paste0("`", names(df), "` ", sapply(df, typeof), ",", collapse = '')
  table_vars <- sub(",$", "", table_vars)

  # SQL create table statement in Athena
  DBI::dbExecute(conn, paste0("CREATE EXTERNAL TABLE IF NOT EXISTS ",
                              database, ".", name, " (", table_vars, " )",
                              "ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'",
                              "WITH SERDEPROPERTIES ('serialization.format' = ',', 'field.delim' = ',' )",
                              "LOCATION 's3://", s3_bucket, "/", name, "/'",
                              "TBLPROPERTIES ('has_encrypted_data'='false', 'skip.header.line.count'='1');"))
}
