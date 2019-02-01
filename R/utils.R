#' Short utility functions for the mobstr package
#'
#' @description{
#' Various utility functions for use with the mobstr package
#' }
#'
#' @importFrom purrr map
#' @importFrom rlang set_names
#'
#' @param var variable name to create lags of
#' @param n number of lags to create
#'
#'
#' @return A vector to include in a call to mutate in dplyr chain
#'
#' @export
#'
lags <- function(var, n = 10){
  var <- enquo(var)

  indices <- seq_len(n)
  map(indices, ~quo(lag(!!var, !!.x))) %>%
    set_names(sprintf("lag_%s_%02d", quo_text(var), indices))
}

