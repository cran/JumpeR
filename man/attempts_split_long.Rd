% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/attempts_split_long.R
\name{attempts_split_long}
\alias{attempts_split_long}
\title{Creates new rows of split attempts strings (long format change)}
\usage{
attempts_split_long(data_to_split)
}
\arguments{
\item{data_to_split}{output from \code{read_results} followed by \code{add_row_numbers}}
}
\value{
returns a dataframe with Flight_X_Attempts columns split into individual attempts as rows
}
\description{
Given a dataframe with columns "Flight_1_Attempts" it will three new rows, one for each of the attempts in flight 1
}
\examples{
\donttest{df <- tf_parse(
read_results("https://www.flashresults.com/2018_Meets/Outdoor/05-05_A10/015-1.pdf"),
flights = TRUE,
flight_attempts = TRUE,
split_attempts = TRUE)

df \%>\%
attempts_split_long()
}
}
\author{
Greg Pilgrim \email{gpilgrim2670@gmail.com}
}
