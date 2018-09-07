#' @export
load_redshift <- function(stock) {
  options <- readRDS(paste0(here::here(), "/data/options/", stock, ".RDS")) %>%
    dplyr::mutate(mid = (bid + ask) / 2)

  # S3 bucket must already exist at this point.
  # TODO - Add code to create the bucket if not exists
  tastytrade::write_2_S3(options, paste0(stock, "_options.csv"), paste0(stock, "-options"))

  # Connect to Redshift
  rs_conn <- tastytrade::redshift_connect("TASTYTRADE")

  if (!RJDBC::dbExistsTable(rs_conn, stock)) {
    RJDBC::dbSendUpdate(rs_conn, paste0("create table if not exists ", stock, "(
      symbol varchar(4) not null,
      quotedate date,
      calliv float(4),
      putiv float(4),
      meaniv float(4),
      callvol float(4),
      putvol float(4),
      calloi float(4),
      putoi float(4),
      open_price float(4),
      high_price float(4),
      low_price float(4),
      close_price float(4),
      volume float(4),
      type varchar(4),
      expiration date,
      strike float(4),
      last float(4),
      bid float(4),
      ask float(4),
      option_volume float(4),
      open_interest float(4),
      iv_strike float(4),
      delta_strike float(4),
      gamma float(4),
      theta float(4),
      vega float(4),
      dte float(4),
      exp_type varchar(8),
      mid float(4))

      distkey (symbol)
      sortkey (symbol, quotedate);"))
  }
  tastytrade::truncate_redshift(rs_conn, stock)
  # Use Manage IAM roles on cluster to add the redshift role prior to copy
  tastytrade::copy_S3_redshift(rs_conn, stock, paste0("s3://", stock, "-options/"))
}
