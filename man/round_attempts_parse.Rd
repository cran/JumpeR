% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/round_attempts_parse.R
\name{round_attempts_parse}
\alias{round_attempts_parse}
\title{Collects results of high jump & pole vault attempts within \code{tf_parse}}
\usage{
round_attempts_parse(text)
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
extracts jump/throw attempts and associated row numbers.
}
\seealso{
\code{round_attempts_parse} runs inside \code{\link{tf_parse}} on
the output of \code{\link{read_results}} with row numbers from
\code{\link{add_row_numbers}}
}
