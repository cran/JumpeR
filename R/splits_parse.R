#' Collects splits within \code{tf_parse}
#'
#' Takes the output of \code{read_results} and, inside of \code{tf_parse},
#' extracts split times and associated row numbers
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr rename_at
#' @importFrom dplyr mutate_at
#' @importFrom dplyr rename
#' @importFrom dplyr vars
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_remove_all
#' @importFrom stringr str_extract_all
#' @importFrom stringr str_split
#' @importFrom stringr str_detect
#' @importFrom purrr map_lgl
#' @importFrom purrr map
#'
#' @param text output of \code{read_results} with row numbers appended by
#'   \code{add_row_numbers}
#' @param split_len the distance at which splits are measured
#' @return returns a data frame with split times and row numbers
#'
#' @seealso \code{splits_parse} runs inside \code{\link{tf_parse}} on the
#'   output of \code{\link{read_results}} with row numbers from
#'   \code{\link{add_row_numbers}}

splits_parse <- function(text, split_len = 1) {

  #### Testing ####
  # text <- read_results("http://results.deltatiming.com/ncaa/tf/2019-joe-walker-invitational/print/190412F010") %>%
  #   add_row_numbers()

  # text <- read_results("http://results.deltatiming.com/ncaa/tf/2019-joe-walker-invitational/190412F009") %>%
  #   add_row_numbers()

  #### Actual Function ####
  ### collect row numbers from rows containing splits ###
  ### define strings ###

  text <- text %>%
    stringr::str_replace_all(" \\:", "  ")

  # split_string <- "\\(\\d?\\:?\\d\\d\\.\\d\\d\\)"
  split_string <- "\\(\\d{0,2}\\:?\\d?\\d\\.\\d\\d\\d?\\)"
  split_string_parens <-
    "\\(\\d{0,2}\\:?\\d\\d\\.\\d\\d\\d?\\)|\\s\\d{0,2}\\:?\\d\\d\\.\\d\\d\\d?\\s|\\s[8-9]\\.\\d{2}"

  row_numbs <- text %>%
    .[stringr::str_detect(.,
                     split_string)] %>%
    stringr::str_extract_all("\\d{1,}$")
  flag <- FALSE

  if (length(row_numbs) == 0) { # looks for splits that don't have parenthesis around them but will also capture rows with normal times

    row_numbs <- text %>%
      .[stringr::str_detect(.,
                       split_string_parens)] %>%
      stringr::str_remove_all("r\\:\\+?\\s?\\d?\\d\\.\\d\\d") %>%
      .[stringr::str_detect(., # remove rows with letters, which should take care of removing normal (non-split) times
                       "[:alpha:]", negate = TRUE)] %>%
      stringr::str_extract_all("\\d{1,}$")
    flag <- TRUE # sets flag to warn for possible rows with letters in them for next step
  }

  #### if there are still no valid splits return blank dataframe ####
  if (length(row_numbs) > 0) {
    minimum_row <- min(as.numeric(row_numbs))
    maximum_row <- as.numeric(length(text))

    #### help out a little, in case there are splits that only have one space between them ####
    text <- stringr::str_replace_all(text, "(\\d) (\\d)", "\\1  \\2")

    #### pull out rows containing splits, which will remove row numbers ####
    if (flag == TRUE) {
      # if there's a risk of rows with letters

      data_1_splits <- text %>%
        .[stringr::str_detect(.,
                         split_string)]

      # in some cases all splits are without parens
      if (length(data_1_splits) < 1) {
        data_1_splits <- text %>%
          .[stringr::str_detect(.,
                           split_string_parens)]

      }
      suppressWarnings(
        data_1_splits <- data_1_splits %>%
          stringr::str_remove_all("r\\:\\+?\\s?\\d?\\d\\.\\d\\d") %>%
          .[stringr::str_detect(.,  # removes rows with letters
                           "[:alpha:]", negate = TRUE)] %>%
          stringr::str_remove_all("\n") %>%
          # stringr::str_remove_all("r\\:\\+?\\s?\\d?\\d\\.\\d\\d") %>%
          stringr::str_extract_all(paste0("^\\s+\\d\\d\\d?\\.\\d\\d\\d?|", split_string_parens)) %>%
          stringr::str_remove_all('\\"') %>%
          stringr::str_replace_all("\\(", " ") %>%
          stringr::str_replace_all("\\)", " ") %>%
          stringr::str_remove_all("c") %>%
          stringr::str_remove_all(',') %>%
          trimws()
      )


    } else {
      suppressWarnings(
        data_1_splits <- text %>%
          .[stringr::str_detect(.,
                           split_string)] %>%
          stringr::str_replace_all("\n", "") %>%
          # stringr::str_replace_all("r\\:\\+\\s?\\d\\.\\d\\d", "") %>%
          stringr::str_remove_all("r\\:\\+?\\s?\\d?\\d\\.\\d\\d\\d?") %>%
          stringr::str_extract_all(
            paste0("^\\s+\\d\\d\\.\\d\\d\\d?|\\s[8-9]\\.\\d{2,3}|", split_string)
          ) %>%
          purrr::map(trimws) %>%
          stringr::str_remove_all('\\"') %>%
          stringr::str_remove_all("c\\(") %>%
          stringr::str_remove_all("\\)$") %>%
          stringr::str_replace_all("\\(", "  qq") %>% # replace parens around splits with qq to make detecting easier
          stringr::str_replace_all("\\)", "qq  ") %>% # replace parens around splits with qq to make detecting easier
          stringr::str_remove_all(',') %>%
          stringr::str_replace_all(" ", "  ") %>%
          trimws()
      )
    }


    #### add row numbers back in since they were removed ####
    data_1_splits <- paste(row_numbs, data_1_splits, sep = "   ")

    #### break out by length ####
    data_1_splits <-
      unlist(purrr::map(data_1_splits, stringr::str_split, "\\s{2,}"),
             recursive = FALSE) %>%
      purrr::map(remove_duplicate_splits)


    data_splits_length_2 <- data_1_splits[purrr::map(data_1_splits, length) == 2]
    data_splits_length_3 <- data_1_splits[purrr::map(data_1_splits, length) == 3]
    data_splits_length_4 <- data_1_splits[purrr::map(data_1_splits, length) == 4]
    data_splits_length_5 <- data_1_splits[purrr::map(data_1_splits, length) == 5]
    data_splits_length_6 <- data_1_splits[purrr::map(data_1_splits, length) == 6]
    data_splits_length_7 <- data_1_splits[purrr::map(data_1_splits, length) == 7]
    data_splits_length_8 <- data_1_splits[purrr::map(data_1_splits, length) == 8]
    data_splits_length_9 <- data_1_splits[purrr::map(data_1_splits, length) == 9]
    data_splits_length_10 <- data_1_splits[purrr::map(data_1_splits, length) == 10]

    #### transform all lists to dataframes ####
    if (length(data_splits_length_10) > 0) {
      df_10_splits <- data_splits_length_10 %>%
        list_transform()
    } else {
      df_10_splits <- data.frame(Row_Numb = character(),
                                 stringsAsFactors = FALSE)
    }

    if (length(data_splits_length_9) > 0) {
      df_9_splits <- data_splits_length_9 %>%
        list_transform()
    } else {
      df_9_splits <- data.frame(Row_Numb = character(),
                                stringsAsFactors = FALSE)
    }

    if (length(data_splits_length_8) > 0) {
      df_8_splits <- data_splits_length_8 %>%
        list_transform()
    } else {
      df_8_splits <- data.frame(Row_Numb = character(),
                                stringsAsFactors = FALSE)
    }

    if (length(data_splits_length_7) > 0) {
      df_7_splits <- data_splits_length_7 %>%
        list_transform()
    } else {
      df_7_splits <- data.frame(Row_Numb = character(),
                                stringsAsFactors = FALSE)
    }

    if (length(data_splits_length_6) > 0) {
      df_6_splits <- data_splits_length_6 %>%
        list_transform()
    } else {
      df_6_splits <- data.frame(Row_Numb = character(),
                                stringsAsFactors = FALSE)
    }

    if (length(data_splits_length_5) > 0) {
      df_5_splits <- data_splits_length_5 %>%
        list_transform()
    } else {
      df_5_splits <- data.frame(Row_Numb = character(),
                                stringsAsFactors = FALSE)
    }

    if (length(data_splits_length_4) > 0) {
      df_4_splits <- data_splits_length_4 %>%
        list_transform()
    } else {
      df_4_splits <- data.frame(Row_Numb = character(),
                                stringsAsFactors = FALSE)
    }

    if (length(data_splits_length_3) > 0) {
      df_3_splits <- data_splits_length_3 %>%
        list_transform()
    } else {
      df_3_splits <- data.frame(Row_Numb = character(),
                                stringsAsFactors = FALSE)
    }

    if (length(data_splits_length_2) > 0) {
      df_2_splits <- data_splits_length_2 %>%
        list_transform()
    } else {
      df_2_splits <- data.frame(Row_Numb = character(),
                                stringsAsFactors = FALSE)
    }

    #### bind up results ####
    # results are bound before going to lines_sort so that in cases where there are multiple rows with splits for the same race,
    # like in longer events with many splits, those splits can be collected and treated together
    data_splits <-
      dplyr::bind_rows(
        df_10_splits,
        df_9_splits,
        df_8_splits,
        df_7_splits,
        df_6_splits,
        df_5_splits,
        df_4_splits,
        df_3_splits,
        df_2_splits
      ) %>%
      lines_sort(min_row = minimum_row) %>%
      dplyr::mutate(Row_Numb = as.numeric(Row_Numb) - 1) # make row number of split match row number of performance


    ### goal here is to deal with cases where there are multiple splits in parens and outside.  Want to keep only fist split outside parens
    ### and remove all others
    ### parens are replaced with "qq" above because dealing with detecting parens is annoying
    if(suppressWarnings(any(stringr::str_detect(data_splits, "qq"))) == TRUE) {
      data_splits <- data_splits %>%
        dplyr::mutate(dplyr::across(
          3:length(data_splits),
          ~ dplyr::case_when(stringr::str_detect(., "qq") == FALSE ~ "NA",
                             TRUE ~ .)
        )) %>%
        dplyr::na_if("NA") %>%
        dplyr::mutate(dplyr::across(
          dplyr::everything(),
          ~ stringr::str_replace_all(., "qq", "")
        )) %>%
        fill_left()

      if("V1" %in% names(data_splits) & any(stringr::str_detect(data_splits$V1, "\\.") == FALSE)){
        data_splits <- data_splits %>%
          dplyr::rename("Row_Numb" = V1)
      }
    }

    #### rename columns V1, V2 etc. by 50 ####
    old_names <- names(data_splits)[grep("^V", names(data_splits))]
    new_names <-
      paste("Split", seq(1, length(names(data_splits)) - 1) * split_len, sep = "_")

    data_splits <- data_splits %>%
      dplyr::rename_at(dplyr::vars(old_names), ~ new_names)

  } else { # if there are no rows with valid splits return blank dataframe
    data_splits <- data.frame(Row_Numb = as.numeric())
  }
  return(data_splits)

}
