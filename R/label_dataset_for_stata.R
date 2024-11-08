#' Add labels readable by STATA to all the columns automatically
#'
#' There are 4 elements that are read in STATA
#' The variable name
#' The variable label
#' The value code
#' The value label
#'
#' Note: is important that you have labels for all the variables
#'
#' @param dataset Any data frame with categorical variables coded as numbers.
#' @param dictionary A data frame that serves as a dictionary,
#' mapping each numeric code to its corresponding category string.
#' @param ignore_columns You don't want to modify the columns that
#' serves as the id of the data or numeric variables
#' that are not categorical variables. You can specify them here.
#' @param var_label Name of the dictionary column containing the
#' dataset variable labels.
#' To understand the dictionary format,
#' refer to the documentation for the `dict_df_var_label` dataset.
#' @param var_colname Name of the dictionary column containing the
#' dataset variable column names.
#' To understand the dictionary format,
#' refer to the documentation for the `dict_df_var_label` dataset.
#' @param num_colname Name of the dictionary column containing
#' the numeric codes for the categories.
#' To understand the dictionary format,
#' refer to the documentation for the `dict_df_var_label` dataset.
#' @param str_colname Name of the dictionary column containing the
#' labels or categories as character strings.
#' To understand the dictionary format,
#' refer to the documentation for the `dict_df_var_label` dataset.
#'
#' @importFrom dplyr filter select pull bind_rows
#' @importFrom tibble tibble
#' @importFrom labelled labelled
#' @importFrom stats setNames
#' @importFrom rlang :=
#'
#' @return The original dataset with variable and code labels
#'
#' @export
#'
#' @examples
#'
#'label_df_for_STATA(dataset = df,
#'                     dictionary = dict_df_var_label,
#'                     ignore_columns = c("id", "age"),
#'                     var_label = var_label ,
#'                     var_colname = variable,
#'                     num_colname = level_num,
#'                     str_colname = level_str)
label_df_for_STATA <- function(dataset,
                                dictionary,
                                ignore_columns,
                                var_label,
                                var_colname,
                                num_colname,
                                str_colname){
  # Variable names
  varnames <- dictionary |>
    select({{var_colname}}) |>
    unique() |>
    pull()

  # STATA needs all the labels to read them correctly.
  # So, we add empty labels to the variables that are not
  # included in the dictionary, if any.
  missing_vars <- tibble(
    "{{var_colname}}" := c(setdiff(colnames(dataset), varnames)),
    "{{var_label}}" := "")

  # add the missing variable labels to the dictionary
  dictionary <- dictionary |>
    bind_rows(missing_vars)

  # Assign variable labels
  for(i in varnames){

    varlabel <- dictionary |>
      filter({{var_colname}} == i) |>
      select({{var_label}}) |>
      unique()

   labelled::var_label(dataset[, i]) <- varlabel[[1]]
  }

  # Assign code labels
  for(i in colnames(dataset)){

    # Ignore numeric columns that shouldn't be labelled.
    if (i %in% ignore_columns) {
      next
    }

    # STATA only supports labeling with numeric variables.
    if (!is.numeric(dataset[, i][[1]])) {
      next
    }

    var_dict <- dictionary |>
      filter({{var_colname}} == i)

    num_dict <- var_dict |>
      select({{num_colname}}) |>
      pull()

    str_dict <- var_dict |>
      select({{num_colname}}) |>
      pull()

  # create a named vector for the labels
  named_vector <- setNames(as.integer(num_dict),
                           str_dict)

  dataset[ , i] <- labelled(dataset[ , i],
                                 labels = named_vector)
  }
   return(dataset)
}
