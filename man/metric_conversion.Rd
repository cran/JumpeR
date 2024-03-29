% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metric_conversion.R
\name{metric_conversion}
\alias{metric_conversion}
\title{Formatting feet-inches lengths as meters}
\usage{
metric_conversion(x)
}
\arguments{
\item{x}{A character vector of distance(s) in feet-inches format (e.g.
"12-07.45"), to be converted to meters ("3.85m")}
}
\value{
returns the value of the string \code{x} which represents a distance
in meters, as a character, with unit "m" included
}
\description{
Takes a character string (or list) representing a length in feet-inches
format (e.g. "12-07.45") and converts it to a distance in meters ("3.85m").
}
\examples{
distances <- c("1.23m", "5-02.34", "43.45", "6.89", NA)
metric_conversion(distances)
math_format(metric_conversion(distances))
metric_conversion("5.45m")
}
