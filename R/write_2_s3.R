#' Write to AWS S3
#'
#' @description{
#' Take processed csv file options file put to AWS S3 bucket
#' }
#'
#' @importFrom dplyr mutate
#' @importFrom utils write.csv
#' @importFrom aws.s3 put_object save_object put_bucket
#' @importFrom here here
#' @importFrom data.table fread
#' @importFrom readr write_csv
#'
#' @param file character string of the file we want to put to S3
#' @param path character string of local file path to upload
#' @param bucket character string of the name for the root AWS S3 bucket
#'
#' @return TRUE when successful copy is made
#'
#' @export
#'

write_2_S3 <- function(file, path, bucket) {
  file_path <- paste0(path, file, ".csv")
  file_name <- paste0(file, ".csv")
  bucket_name <- paste0(bucket, "/", file)
  region_name <- Sys.getenv("AWS_S3_REGION")

  aws.s3::put_bucket(bucket_name)

  aws.s3::put_object(file = file_path,
                     object = file_name,
                     bucket = bucket_name,
                     region = region_name)
}
