#' Determines if a link is valid
#'
#' Used in testing links to external data, specifically inside of internal
#' package tests. Attempts to connect to link for the length of duration (in s).
#' If it fails it returns \code{TRUE}
#'
#' @param link_to_test a link
#' @param duration the lowest row number
#' @return \code{FALSE} if the link works, \code{TRUE} if it fails
#'
#' @export


is_link_broken <- function(link_to_test, duration = 1) {
  link_to_test <- url(link_to_test)
  result <-
    suppressWarnings(try(open.connection(link_to_test, open = "rt", timeout = duration),
                         silent =
                           TRUE)
                     [1])

  suppressWarnings(try(close.connection(link_to_test), silent = TRUE)
  )
  ifelse(is.null(result), FALSE, TRUE)

}
