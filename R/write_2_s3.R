#' Write to AWS S3
#'
#' @description{
#' Take processed RDS stock options file and convert to CSV then put to AWS S3
#' bucket
#' }
#'
#' @importFrom dplyr mutate
#' @importFrom utils write.csv
#' @importFrom aws.s3 put_object save_object put_bucket
#' @importFrom here here
#' @importFrom data.table fread
#' @importFrom readr write_csv
#'
#' @param stock character string of the stock we want to put to S3
#'
#' @return TRUE when successful copy is made
#'
#' @export
#'
# write_2_S3 <- function(stock) {
#   file_name <- paste0(stock, "_options.csv")
#   bucket_name <- "rds-options-files"
#   region_name <- Sys.getenv("AWS_S3_REGION")
#
#   df <- readRDS(paste0(here(), "/data/options/", stock, ".RDS")) %>%
#     mutate(mid = (.data$bid + .data$ask) / 2)
#
#   tmp <- tempfile()
#   on.exit(unlink(tmp))
#   write.csv(df, file = tmp, row.names = FALSE)
#   # S3 bucket must already exist at this point
#   put_object(tmp,
#              object = file_name,
#              bucket = bucket_name,
#              region = region_name)
# }


write_2_S3 <- function(stock) {
  file_name <- paste0(stock, "_options.csv")

  aws.s3::save_object(paste0("s3://rds-options-files/", stock, "_options.csv"), file = file_name)
  df <- data.table::fread(file_name)

  bucket_name <- paste0("rds-options-files/", stock)
  region_name <- Sys.getenv("AWS_S3_REGION")

  aws.s3::put_bucket(bucket_name)

  tmp <- tempfile()
  on.exit(unlink(tmp))
  readr::write_csv(df, path = tmp)

  aws.s3::put_object(tmp,
             object = file_name,
             bucket = bucket_name,
             region = region_name)
}