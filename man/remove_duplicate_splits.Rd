% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/remove_duplicate_splits.R
\name{remove_duplicate_splits}
\alias{remove_duplicate_splits}
\title{Removes duplicate splits}
\usage{
remove_duplicate_splits(x)
}
\arguments{
\item{x}{a list of splits, in which position 2 and position 3 might be duplicates}
}
\value{
a list with duplicated value in position 2 removed
}
\description{
Removes duplicate splits
}
\seealso{
\code{remove_duplicate_splits} is a helper function inside \code{splits_parse}
}
