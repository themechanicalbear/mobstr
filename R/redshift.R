#' @export
# Download Amazon Redshift JDBC driver
# download.file('http://s3.amazonaws.com/redshift-downloads/drivers/RedshiftJDBC41-1.1.9.1009.jar','RedshiftJDBC41-1.1.9.1009.jar')

# Connect to Amazon Redshift
redshift_connect <- function(env) {
  rs_driver <- RJDBC::JDBC(Sys.getenv("REDSHIFT_DRIVER"),
                           Sys.getenv("REDSHIFT_DRIVER_FILE"),
                           identifier.quote = "`")
  rs_url <- paste0(Sys.getenv(paste0(env, "_REDSHIFT_JDBC_URL")),
                   "user=", Sys.getenv(paste0(env, "_REDSHIFT_ADMN_USER")),
                   "&password=", Sys.getenv(paste0(env, "_REDSHIFT_ADMN_PASS")))
  RJDBC::dbConnect(rs_driver, rs_url)
}