#' Replaces in a data frame values coded as "missing" in the dictionary with NA
#'
#' @description
#' In the dictionary,
#' there are often specific numeric codes
#' used to represent missing observations
#' (for example, a common one is -99).
#'
#' Although it’s usually the same value,
#' there may be more than one.
#' For example, the Canadian Longitudinal Study in Aging (CLSA)
#' distinguishes between -9999 for missing values
#' and -8888 for cases where the respondent did not answer.
#'
#' The function `replace_missing_with_na` assumes
#' the presence of a column (called `missing` in CLSA dictionary)
#' that codes 0 if the value is present and 1 if it is absent.
#'
#' Notice that it would be relatively straightforward
#' to remove rows where `missing == 1` to remove missing data.
#' The purpose of `replace_with_na()` is to convert
#' coded values to `NA` to accurately estimate
#' the total amount of missing data in the database,
#' regardless of the reason.
#'
#' @param dataset Any data frame with categorical variables coded as numbers.
#' To see an example you can refer to the documentation
#' for the data frame [df_missing].
#' @param dictionary A data frame that serves as a dictionary,
#' mapping each numeric code to its corresponding category string.
#' This dictionary includes a column that indicates
#' whether a number represents a missing value (1)
#' or a reported value (0).
#' In CLSA, this column is included by default and
#' is called `missing`.
#' If you wish to use this function with another dataset,
#' you can create this column.
#' To understand what the dictionary looks like,
#' you can refer to the documentation
#' for the example dictionary [dict_df_missing].
#' @param ignore_columns You don't want to modify the columns that
#' serves as the id of the data or numeric variables
#' that are not categorical variables.
#' You can specify them here.
#' @param var_colname Name of the dictionary column containing the
#' dataset variable names. To understand the dataset format,
#'refer to the documentation for the `df_missing` dataset.
#' @param num_colname Name of the dictionary column containing
#' the numeric codes for the categories.
#' To understand the dataset format,
#' refer to the documentation for the `df_missing` dataset.
#' @param missing_colname Name of the dictionary column that
#' is a binary indicator where a value of 1 represents a missing
#' or unreported observation, and a value of 0
#' represents a reported observation.
#' To understand the dataset format,
#' refer to the documentation for the `df_missing` dataset.
#'
#' @return
#' @export
#'
#' @examples
#'
#' replace_missing_with_na(dataset = df_missing,
#'                         ignore_columns = c(id, age),
#'                         dictionary = dict_df_missing,
#'                         var_colname = variable,
#'                         num_colname = level_num,
#'                         missing_colname = missing)
replace_missing_with_na <- function(dataset,
                                    ignore_columns,
                                    dictionary,
                                    var_colname,
                                    num_colname,
                                    missing_colname) {

  # Extract column names type numeric
  # Allow ignoring specific cases (i.e. the id)
  vars_numeric <- dataset |>
    select(where( ~ is.numeric(.)),
           -{{ignore_columns}}) |> colnames()


  for (i in vars_numeric) {

    # extracts variable
    var <- dataset[, i]


    # skip cases where there are not missing values reported
    # or where there are no values reported for that variable
    missing_data <- dictionary |> select({{missing_colname}})
    if(!any(missing_data == 1) | all(is.na(missing_data))) next

    # keep only the variable of interest
    dict <- dictionary |>
      filter({{var_colname}} == i,
             {{missing_colname}} == 1)

    # replace the missing value with NA

    dict_num <- dict |> select({{num_colname}}) |>  pull()

    var[var %in% as.numeric(dict_num)] <- NA

    dataset[, i] <- var

  }
  return(dataset)
}
