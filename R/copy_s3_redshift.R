#' @export
# Copy data from S3 and append to redshift
copy_S3_redshift <- function(connection, table_name, bucket_path,
                             credentials = Sys.getenv("TASTYTRADE_REDSHIFT_IAM_ROLE"),
                             role =  Sys.getenv("TASTYTRADE_REDSHIFT_S3_ROLE"),
                             delimiter = ",",
                             region= Sys.getenv("TASTYTRADE_REDSHIFT_REGION"),
                             ignore_header = "1",
                             dateformat = "auto",
                             null = "NA",
                             file_format = "csv") {

  RJDBC::dbSendUpdate(connection, paste0("COPY ", table_name, " FROM '", bucket_path,"'credentials '",
                                         credentials, ":role/", role, "' delimiter '", delimiter, "' region '",
                                         region, "' IGNOREHEADER ", ignore_header, " dateformat '", dateformat,
                                         "' NULL '", null, "' ", file_format, ";"))
}