% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flash_flights_parse.R
\name{flash_rounds_parse}
\alias{flash_rounds_parse}
\title{Collects attempts within \code{tf_parse}}
\usage{
flash_rounds_parse(text)
}
\arguments{
\item{text}{output of \code{read_results} with row numbers appended by
\code{add_row_numbers}}
}
\value{
returns a data frame with split times and row numbers
}
\description{
Takes the output of \code{read_results} and, inside of \code{tf_parse},
extracts jump/throw attempts and associated row numbers
}
\seealso{
\code{rounds_parse_flash} runs inside \code{\link{flash_parse}} on
the output of \code{\link{read_results}} with row numbers from
\code{\link{add_row_numbers}}
}
