#' @export
# Write to S3
write_2_S3 <- function(df, file_name, bucket_name) {
  tmp <- tempfile()
  on.exit(unlink(tmp))
  utils::write.csv(df, file = tmp, row.names = FALSE)
  aws.s3::put_object(tmp, object = file_name, bucket = bucket_name)
}