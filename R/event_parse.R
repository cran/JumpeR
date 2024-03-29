#' Pulls out event labels from text
#'
#' Locates event labels in text of results output from \code{read_results} and
#' their associated row numbers.  The resulting data frame is joined back into
#' results to include event names.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr lead
#' @importFrom stringr str_replace
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_extract
#' @importFrom stringr str_split
#' @importFrom stringr str_detect
#' @importFrom purrr map_lgl
#' @importFrom purrr map
#'
#' @param text output from \code{read_results} followed by
#'   \code{add_row_numbers}
#' @return returns a data frame with event names and row numbers to eventually
#'   be recombined with track and field results inside \code{tf_parse}
#'
#' @seealso \code{event_parse} is a helper function inside
#'   \code{\link{tf_parse}}

event_parse <- function(text) {

  # text <- as_lines_list_2
  # text <- raw_results[31] %>%
  #   unlist() %>%
  #   add_row_numbers()

  #### Build event names ####
  genders <- c("Women", 'Girls', "Men", "Boys", "Mixed")
  space1 <- " .*"
  events_parts <- c("Yard", "Meter", "Y", "M", "Long", "High", "Triple", "Pole", "Pentathlon", "Decathlon", "Heptathlon", "Shot Put", "Javelin", "Weight", "Hammer", "Discus", "Medley", "Race", "Steeple", "Mile", "Relay")

  event_string <-
    as.vector(outer(genders, events_parts, paste, sep = space1)) %>%
    unique() %>%
    paste(collapse = "|") %>%
    paste0("|Event \\d{1,}")

  #### Pull out event names ####
  events <- text %>%
    .[stringr::str_detect(.,
                     event_string)]

  if (length(events) > 0) {
    #if event names are recognized clean them up and determine row ranges

    events <- stringr::str_replace(events, ".*Event \\d{1,4} ", "")
    events <- stringr::str_replace(events, "Open  ", "") ## Addition
    events <-
      stringr::str_replace(events, "1 M  ", "1 M ") ## Addition
    events <- stringr::str_replace(events, "([^1])0  ", "\\10 ")
    events <- stringr::str_replace(events, " Class [:alpha:]", "")
    events <- stringr::str_replace(events, " m ", "m ")
    events <- events %>% # Addition
      .[stringr::str_detect(., "[[:alpha:]]")] %>%
      stringr::str_replace_all("\\\n", "") %>%
      stringr::str_replace_all("\\(", "") %>%
      stringr::str_replace_all("\\)", "") %>%
      # stringr::str_replace(".*(?=(Wom|Men|Boy|Girl))", "") %>% # new 10/16
      str_replace_all("\\s{2,}", " ") %>% # in case there are improperly formatted events with to many spaces - 1
      str_replace(" (\\d{1,}$)", "   \\1") %>% # in case there are improperly formatted events with to many spaces - 2 - moves row numbers back out multiple spaces
      trimws()

    events <-
      unlist(purrr::map(events, stringr::str_split, "\\s{2,}"),
             recursive = FALSE)

    # data frame for events with names and row number ranges
    events <- events %>%
      list_transform() %>%
      dplyr::mutate(
        Event = stringr::str_extract(V1, "[[:graph:] ]*"),
        Event_Row_Min = as.numeric(V2),
        Event_Row_Max = dplyr::lead(Event_Row_Min, 1L, default = length(text)) - 1,
        V1 = NULL,
        V2 = NULL
      )
  } else{
    # if no event names are recognized deploy dummy dataframe with event name "unknown" and post warning
    events <- data.frame(
      Event = "Unknown",
      Event_Row_Min = 1,
      Event_Row_Max = length(text) - 1,
      stringsAsFactors = FALSE
    )
    warning("No event names recognized - defaulting to 'Unknown'")
  }
  return(events)
}
