% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flights_parse.R
\name{flights_parse}
\alias{flights_parse}
\title{Collects flights within \code{tf_parse}}
\usage{
flights_parse(text)
}
\arguments{
\item{text}{output of \code{read_results} with row numbers appended by \code{add_row_numbers}}
}
\value{
returns a dataframe with split times and row numbers
}
\description{
Takes the output of \code{read_results} and, inside of \code{tf_parse}, extracts jump/throw flights and associated row numbers
}
\seealso{
\code{flights_parse} runs inside \code{\link{tf_parse}} on the output of \code{\link{read_results}} with row numbers from \code{\link{add_row_numbers}}
}
\author{
Greg Pilgrim \email{gpilgrim2670@gmail.com}
}
