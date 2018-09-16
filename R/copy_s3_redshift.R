#' Copy data stored in S3 .csv files into redshift table
#'
#' @description{
#' Using function inputs for JDBC connection, redshift table name, and bucket
#' path, perform copy/insert to redshift
#' }
#'
#' @importFrom RJDBC dbSendUpdate
#'
#' @param env variable for AWS to select specific systems using getenv query
#' @param connection RJDBC connection string
#' @param table_name name of the table in redshift to copy to
#' @param bucket_path name of the S3 bucket the includes the csv to copy
#' @param credentials IAM role with access defined in .RProfile
#' @param role S3 role with access defined in .RProfile
#' @param delimiter identifier for column seperation
#' @param region AWS region for redshift cluster defined in .RProfile
#' @param ignore_header default ignore header to TRUE
#' @param dateformat format for data fields in redshift cluster default 'auto'
#' @param null fill value for nulls in redshift
#' @param file_format file format to upload/copy/insert
#'
#' @export
#'
#'
#' @return return TRUE if successful
#'
#' @examples
#' tastytrade::copy_S3_redshift(rs_conn, stock, paste0("s3://", stock, "-options/"))
#'
#'
# Function ----
copy_S3_redshift <-
  function(env, connection, table_name, bucket_path,
           credentials = Sys.getenv(paste0(env, "_REDSHIFT_IAM_ROLE")),
           role =  Sys.getenv(paste0(env, "_REDSHIFT_S3_ROLE")),
           delimiter = ",",
           region= Sys.getenv(paste0(env, "_REDSHIFT_REGION")),
           ignore_header = "1",
           dateformat = "auto",
           null = "NA",
           file_format = "csv") {

    dbSendUpdate(connection,
                 paste0("COPY ", table_name, " FROM '", bucket_path,
                        "'credentials '", credentials, ":role/", role,
                        "' delimiter '", delimiter, "' region '",
                        region, "' IGNOREHEADER ", ignore_header,
                        " dateformat '", dateformat, "' NULL '", null,
                        "' ", file_format, ";"))
  }
