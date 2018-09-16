#' Write to AWS S3
#'
#' @description{
#' Take processed RDS stock options file and convert to CSV then put to AWS S3
#' bucket
#' }
#'
#' @importFrom dplyr mutate
#' @importFrom utils write.csv
#' @importFrom aws.s3 put_object
#' @importFrom here here
#'
#' @param stock character string of the stock we want to put to S3
#'
#' @export
#'
#' @return TRUE when successful copy is made
#'
#' @examples
#' walk(watch_list$Symbol, tastytrade::write_2_S3)
#'
# Function ----
write_2_S3 <- function(stock) {
  file_name <- paste0(stock, "_options.csv")
  bucket_name <- "rds-options-files"
  region_name <- Sys.getenv("AWS_S3_REGION")

  df <- readRDS(paste0(here(), "/data/options/", stock, ".RDS")) %>%
    mutate(mid = (bid + ask) / 2)

  tmp <- tempfile()
  on.exit(unlink(tmp))
  write.csv(df, file = tmp, row.names = FALSE)
  # S3 bucket must already exist at this point
  put_object(tmp,
             object = file_name,
             bucket = bucket_name,
             region = region_name)
}
