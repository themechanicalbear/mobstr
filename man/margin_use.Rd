% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/margin_use.R
\name{margin_use}
\alias{margin_use}
\title{Calculate amount of margin in use}
\usage{
margin_use(sy, st, en, marg)
}
\arguments{
\item{sy}{character string representing stock symbol for group and join later}

\item{st}{character string understood by lubridate ymd to represent open date of trade}

\item{en}{character string understood by lubridate ymd to represent closing date of trade}

\item{marg}{numeric of the margin at open for this position}
}
\value{
dataframe of dates when position was open including stock symbol and margin
}
\description{
{
Calculate the amount of margin in use each day during the study. Can be used
as a decision point on if new positions can be opened
}
}
