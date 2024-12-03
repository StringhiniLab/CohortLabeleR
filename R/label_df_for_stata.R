#' Add variable and value labels compatible with STATA
#' to a complete dataset
#'
#' `label_df_for_STATA()` allows you to add labels to variable names
#' and categorical numeric variables observations (called here "values").
#' The function applies labels to the entire dataset
#' by reading information from a dictionary.
#' For an example of the required dictionary format,
#' check the dataset `dict_df_var_label` included as part
#' of this package.
#'
#' For variable name labels,
#' the function `label_df_for_STATA()` fills in missing labels
#' from the dictionary with empty labels.
#' This means that the function won’t fail due to missing labels.
#'
#' For value labels,
#' you can specify the numeric variables
#' that don't need labeling as they are not categorical
#' (e.g., `id` and `age`).
#' Note that STATA only reads labels for numeric variables.
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

  # Extract variable names
  varnames <- dictionary |>
    select({{var_colname}}) |>
    filter(
      {{var_colname}} %in% colnames(dataset)) |> # I remove the variables that are not in the data
    unique() |>
    pull()

  # The dictionary should not have more entries than the
  # dataset for the loop
  dictionary <-
    dictionary |> filter(
      {{var_colname}} %in% colnames(dataset))

  # STATA needs all the labels to read them correctly.
  # So, we add empty labels to the variables that are not
  # included in the dictionary, if any.
    if(!setequal(colnames(dataset), varnames)){
  missing_vars <- tibble(
    "{{var_colname}}" := c(setdiff(colnames(dataset),
                                   varnames)),
    "{{var_label}}" := "")

  # add the missing variable labels to the dictionary
  dictionary <- dictionary |>
    bind_rows(missing_vars)
    }

  dataset <- assign_value_labels(dataset = dataset,
                                 dictionary = dictionary,
                                 ignore_columns = ignore_columns,
                                 var_label = var_label,
                                 var_colname = variable,
                                 num_colname = level_num,
                                 str_colname = level_str)


  dataset <- assign_variable_labels(dataset = dataset,
                         dictionary = dictionary,
                         ignore_columns = ignore_columns,
                         var_label = var_label,
                         var_colname = variable,
                         varnames = varnames)

   return(dataset)
}


#' Asign value labels
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
#' @importFrom dplyr select pull
#' @importFrom labelled labelled
#' @importFrom stats setNames
#'
#' @return The original dataset with value labels
#' @export
#'
#' @examples
#'
#' assign_value_labels(dataset = df,
#'                     dictionary = dict_df_var_label,
#'                     ignore_columns = c("id", "age"),
#'                     var_label = var_label ,
#'                     var_colname = variable,
#'                     num_colname = level_num,
#'                     str_colname = level_str)
#'
assign_value_labels <- function(dataset,
                                dictionary,
                                ignore_columns,
                                var_label,
                                var_colname,
                                num_colname,
                                str_colname) {
  # Assign value labels
  # IMPORTANT! This step should be done before using labelled()
  # because that function discard previous arguments
  for (i in colnames(dataset)) {
    # Ignore numeric columns that shouldn't be labelled.
    if (i %in% ignore_columns) {
      next
    }

    # STATA only supports labeling with numeric variables.
    if (is.numeric(dataset[, i][[1]])) {
      var_dict <- dictionary |>
        filter({{
            var_colname }} == i)

      num_dict <- var_dict |>
        select({{
            num_colname }}) |>
        pull()

      str_dict <- var_dict |>
        select({{
            str_colname }}) |>
        pull()

      # create a named vector for the labels
      named_vector <- setNames(as.integer(num_dict),
                               str_dict)

      dataset[, i] <- labelled(dataset[, i][[1]],
                               labels = named_vector)
    }
  }
return(dataset)
}


#' Assign variable labels
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
#' @param varnames Variable names
#'
#' @importFrom dplyr filter select pull
#' @importFrom labelled var_label
#'
#' @return The original dataset with variable labels
#' @export
#'
#' @examples
#'
#' library(dplyr)
#'
#' varnames <- dict_df_var_label |>
#' select(variable) |>
#' filter(
#'    variable %in% colnames(df)) |> # I remove the variables that are not in the data
#'  unique() |>
#'  pull()
#'
#' assign_variable_labels(dataset = df,
#'                     dictionary = dict_df_var_label,
#'                     ignore_columns = c("id", "age"),
#'                     var_label = var_label ,
#'                     var_colname = variable,
#'                     varnames = varnames)
#'
assign_variable_labels <- function(dataset,
                                   dictionary,
                                   ignore_columns,
                                   var_label,
                                   var_colname,
                                   varnames){

  # Assign variable labels
  for(i in varnames){

    varlabel <- dictionary |>
      filter({{var_colname}} == i) |>
      select({{var_label}}) |>
      unique()

    if (length(varlabel) > 1) {
      stop("Error: The dictionary has duplicated labels for at least one variable.")
    }

    labelled::var_label(dataset[, i]) <- varlabel[[1]]
  }
return(dataset)
}
