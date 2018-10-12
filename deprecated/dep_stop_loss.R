#' @export
stop_loss <- function(df, col_name) {
  var_name <- col_name
  varQ <- quo(!! sym(var_name))

  s_loss <- df %>%
    dplyr::group_by(open_date) %>%
    dplyr::filter(!! varQ == 1 | quotedate == expiration) %>%
    dplyr::filter(quotedate == min(quotedate)) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(quotedate) %>%
    dplyr::mutate(portfolio = cumsum(profit) * 100) %>%
    dplyr::mutate(loss_type = var_name)

  assign(paste0(var_name), s_loss, envir = .GlobalEnv)
}