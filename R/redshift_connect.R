#' Connect to Amazon Redshift
#'
#' Download Amazon Redshift JDBC driver
#' download.file('http://s3.amazonaws.com/redshift-downloads/drivers/RedshiftJDBC41-1.1.9.1009.jar','RedshiftJDBC41-1.1.9.1009.jar')
#'
#' Install commandline tools for MAC after updating the OS
#' https://developer.apple.com/download/more/
#'
#' @description{
#' Make an RJDBC connection to an Amazon Redshift cluster using settings from
#' the environment variables loaded with .RProfile
#' }
#'
#' @importFrom RJDBC JDBC
#' @importFrom RJDBC dbConnect
#'
#' @param env variable used to create paths for various systems on AWS
#'
#'
#' @export
#'
redshift_connect <- function(env) {
  rs_driver <- RJDBC::JDBC(Sys.getenv("REDSHIFT_DRIVER"),
                           Sys.getenv("REDSHIFT_DRIVER_FILE"),
                           identifier.quote = "`")
  rs_url <- paste0(Sys.getenv(paste0(env, "_REDSHIFT_JDBC_URL")),
                   "user=", Sys.getenv(paste0(env, "_REDSHIFT_ADMN_USER")),
                   "&password=", Sys.getenv(paste0(env, "_REDSHIFT_ADMN_PASS")))
  RJDBC::dbConnect(rs_driver, rs_url)
}
