suppressMessages(library(data.table))
suppressMessages(library(dplyr))
suppressMessages(library(bit64))
suppressMessages(library(lubridate))
suppressMessages(library(RcppBDT))
suppressMessages(library(purrr))
options(scipen = 50)

# Unzip files into one folder per year
uzip_fun <- function(year) {
  # Grab file list from the compressed data folder
  zip_list <- list.files(paste0(here::here(), "/data/raw_files/options_data"),
                         pattern = as.character(year), full.names = TRUE)

  # Unzip files into folder for that year outside icloud path to keep from uploading the extracted files
  purrr::pmap(list(zip_list, exdir = paste0("~/options_data/unzipped/", year)),
              utils::unzip)
}

# purrr::map(2012:2017, uzip_fun)

# Liquid symbols list
load(paste0(here::here(), "/data/liquid_list.RData"))
# TODO Update the market closed dates in the next file each year
market_closed <- readRDS(paste0(here::here(), "/data/market_closed.RDS"))

# Month and Year list to process
cal <- tools::file_path_sans_ext(list.files(paste0(here::here(), "/data/raw_files/options_data"),
                                            pattern = "*.zip", full.names = FALSE))

cal <- data.frame(cal) %>%
  tidyr::separate(cal, c("year", "month"), "_") %>%
  mutate(date = as.Date(paste0("01-", month, "-", year), format = "%d-%B-%Y")) %>%
  mutate(month = lubridate::month(date)) %>%
  select(-date) %>%
  mutate(month = stringr::str_pad(month, 2, pad = "0"))

# Build expiration friday calendar function
third_friday <- function(start_yr, end_yr) {
  range_yr <- list(seq(start_yr, end_yr, by = 1))
  calendar <- data.frame(mon = unlist(rep(list(1:12), length(range_yr))),
                         year = sort(mapply(rep, range_yr, 12)))

  monthy_exp_date <- sapply(1:nrow(calendar),
                            function(i) format(getNthDayOfWeek(third, Fri,
                                                               calendar[i,1],
                                                               calendar[i,2])))
  monthy_exp_date <- as.Date(monthy_exp_date)
}

# Third Friday expiration dates
monthy_exp_dates <- third_friday(min(cal$year), max(cal$year))

# Process raw files
raw_processing <- function(yr, mon) {
  raw_folder <- paste0("~/options_data/unzipped/", yr)
  # processed_folder <- paste0(here::here(), "/data/processed/", yr, "/")

  # Raw files for each month to process after zip extraction
  op_ptrn <- paste0("options_", yr, mon)
  stats_ptrn <- paste0("optionstats_", yr, mon)
  quotes_ptrn <- paste0("stockquotes_", yr, mon)

  options_files <- list.files(path = raw_folder, pattern = op_ptrn, full.names = TRUE)
  stats_files <- list.files(path = raw_folder, pattern = stats_ptrn, full.names = TRUE)
  quotes_files <- list.files(path = raw_folder, pattern = quotes_ptrn, full.names = TRUE)

  options_files <- lapply(options_files, fread, sep = ",")
  stats_files <- lapply(stats_files, fread, sep = ",")
  quotes_files <- lapply(quotes_files, fread, sep = ",", integer64 = "numeric")

  options <- bind_rows(options_files) %>%
    select(-c(Exchange, OptionExt, AKA, OptionSymbol)) %>%
    mutate(Expiration = as.Date(Expiration, "%m/%d/%Y"),
           DataDate = as.Date(DataDate, "%m/%d/%Y"),
           dte = Expiration - DataDate)

  colnames(options) <- c("symbol", "close", "type", "expiration", "quotedate", "strike", "last",
                         "bid", "ask", "option_volume", "open_interest", "iv_strike", "delta",
                         "gamma", "theta", "vega", "dte")

  stats <- bind_rows(stats_files) %>%
    mutate(quotedate = as.Date(as.character(quotedate), "%Y%m%d"))

  quotes <- bind_rows(quotes_files) %>%
    mutate(quotedate = as.Date(quotedate, "%m/%d/%Y"))

  data <- full_join(stats, quotes, by = c("symbol", "quotedate")) %>%
    filter(!is.na(calliv),
           !is.na(close)) %>%
    full_join(options, by = c("symbol", "quotedate", "close")) %>%
    filter(symbol %in% liquid_list$ticker,
           !is.na(type),
           !quotedate %in% market_closed) %>%
    mutate(dte = as.numeric(dte),
           calloi = as.integer(calloi),
           exp_day = weekdays(expiration, abbreviate = FALSE),
           expiration = as.Date(ifelse(exp_day == "Saturday",
                                       expiration - 1,
                                       expiration), origin = "1970-01-01"),
           expiration = as.Date(ifelse(expiration %in% market_closed,
                                       expiration - 1,
                                       expiration), origin = "1970-01-01"),
           dte = as.integer(expiration - quotedate),
           exp_type = ifelse(is.element(expiration, monthy_exp_dates),
                             "Monthly", "Weekly")) %>%
    tidyr::replace_na(list(vega = 0, theta = 0, delta = 0, calliv = 0, putiv = 0, meaniv = 0,
                           callvol = 0, putvol = 0, calloi = 0, putoi = 0, open = 0, high = 0,
                           low = 0, volume = 0)) %>%
    select(-c(exp_day, comment))

  if (!dir.exists(paste0("~/options_data/processed/", yr))) {
    dir.create(paste0("~/options_data/processed/", yr))
  }

  saveRDS(data, file = paste0("~/options_data/processed/", yr, "/",
                              lubridate::month(min(data$quotedate), abbr = TRUE, label = TRUE),
                              "_", lubridate::year(min(data$quotedate)), ".RDS"))
}

# cal_sub <- filter(cal, year == "2018")
#purrr::pmap(list(cal$year, cal$month), raw_processing)

yr <- as.character(c(2012:2018))

calendar <- data.frame(year = rep(yr, 12), month = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
# calendar <- filter(calendar, year == "2018", month == "Jan")

save_dfs <- function(df) {
  sym <- unlist(strsplit(df, "_"))[1]
  if (!dir.exists(paste0("~/options_data/processed/symbols/", sym, "/"))) {
    dir.create(paste0("~/options_data/processed/symbols/", sym, "/"))
    #saveRDS(s[[df]], file = paste0(ext_root_path, "symbols/", sym, "/", df, ".RDS"))
  }
    saveRDS(s[[df]], file = paste0("~/options_data/processed/symbols/", sym, "/", df, ".RDS"))
}

group_save <- function(year, month) {
  x <- readRDS(paste0("~/options_data/processed/", year, "/", month, "_", year, ".RDS"))
  s <<- split(x, x$symbol)
  names(s) <<- paste0(names(s), "_", month, "_", year)
  purrr::map(names(s), save_dfs)
}

# purrr::pmap(list(calendar$year, calendar$month), group_save)

dir_list <- list.dirs(path = "~/options_data/processed/symbols/", full.names = TRUE, recursive = TRUE)
dir_list <- dir_list[-1] # Remove the symbols folder from list created from recursive

combine_files <- function(flz) {
  dir_list_symbol <- list.files(path = flz, full.names = TRUE, recursive = TRUE)
  dat_list <- lapply(dir_list_symbol, function(x) data.table(readRDS(x)))
  dat <- rbindlist(dat_list, fill = TRUE)
  readr::write_csv(dat, path = paste0("~/options_data/processed/", "complete/", dat[1, symbol], ".csv"))

  # saveRDS(dat, file = paste0("~/options_data/processed/", "complete/", dat[1, symbol], ".RDS"))
}
purrr::map(dir_list[501:750], combine_files)

