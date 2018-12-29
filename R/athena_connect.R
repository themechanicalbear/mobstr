#' Connect to Amazon Athena
#'
#' Download Amazon Athena ODBC driver
#' https://s3.amazonaws.com/athena-downloads/drivers/ODBC/SimbaAthenaODBC_1.0.4/OSX/Simba+Athena+1.0.dmg'
#'
#'
#' @description{
#' Make an ODBC connection to an Amazon Athena using settings from
#' the environment variables loaded with .RProfile
#' }
#'
#' @importFrom DBI dbConnect
#' @importFrom odbc odbc
#'
#' @param database string representing the database name in AWS Athena
#'
#' @export
#'
athena_connect <- function(database) {
  DBI::dbConnect(
    odbc::odbc(),
    driver = Sys.getenv("AWS_ATHENA_DRIVER_FILE"),
    Schema = database,
    AwsRegion = Sys.getenv("AWS_DEFAULT_REGION"),
    UID = Sys.getenv("AWS_ACCESS_KEY_ID"),
    PWD = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
    S3OutputLocation = Sys.getenv("AWS_ATHENA_S3_OUTPUT")
  )
}
