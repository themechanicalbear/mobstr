#' Short utility functions for the tastytrade package
#'
#' @description{
#' Various utility functions for use with the tastytrade package
#' }
#'
#' @importFrom purrr map
#' @importFrom rlang set_names
#'
#' @param var variable name to create lags of
#' @param n number of lags to create
#'
#' @export
#'
#' @return A vector to include in a call to mutate in dplyr chain
#'
#' @examples
#'
#'
# Function lags----
# https://purrple.cat/blog/2018/03/02/multiple-lags-with-tidy-evaluation/
lags <- function(var, n = 10){
  var <- enquo(var)

  indices <- seq_len(n)
  map(indices, ~quo(lag(!!var, !!.x))) %>%
    set_names(sprintf("lag_%s_%02d", quo_text(var), indices))
}

