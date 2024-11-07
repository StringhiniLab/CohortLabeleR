#' Recode all numeric codes in a data frame to categorical labels
#' using a dictionary
#'
#' @description
#' Categorical variables are often entered in databases as numbers,
#' with each number representing a specific category.
#' Which category corresponds to each number
#' is typically coded in the dictionary.
#'
#' This function allows you to replace ALL the
#' numeric values representing categories with
#' the associated string in a data frame.
#' This functionality can be particularly useful
#' when plotting multiple variables at once,
#' as it avoids the need to manually replace axis labels
#' for each plot.
#'
#' @param dataset Any data frame with categorical variables
#' @param dictionary A data frame that serves as a dictionary,
#' mapping each numeric code to its corresponding category string.
#' @param ignore_colnames You don't want to recode the columns that
#' serves as the id of the data. You can specify them here.
#' @param var_colname Name of the dictionary column containing the
#' dataset variable names. To understand the dataset format,
#'  refer to the documentation for the `df` dataset.
#' @param num_colname Name of the dictionary column containing
#' the numeric codes for the categories. To understand the dataset format,
#' refer to the documentation for the `df` dataset.
#' @param str_colname Name of the dictionary column containing the
#' labels or categories as character strings. To understand the dataset
#' format, refer to the documentation for the `df` dataset.
#'
#' @return A data frame identical to the original dataset,
#' but with numeric category values replaced by
#' their corresponding label in the specified columns.
#'
#' @export
#'
#' @examples
#' recode_vars(data = df,
#'             ignore_colnames = c(id, age),
#'             dictionary = dict_df,
#'             var_colname = variable,
#'             num_colname = level_num,
#'             str_colname = level_str)
recode_vars <- function(dataset,
                        dictionary,
                        ignore_colnames,
                        var_colname,
                        num_colname,
                        str_colname) {
  # selection of variables that need factor categories label replacement
  data_recode <-  dataset |>
    select(where( ~ is.numeric(.)),
           -{{ignore_colnames}})

  vars_recode <- colnames(data_recode)

   for (i in vars_recode) {

     key <-  dictionary |>
       dplyr::filter({{var_colname}} == i) |>
       dplyr::select({{num_colname}},
                     {{str_colname}})

     data_recode2 <- data_recode[, i]

     keystr <- key |> select({{str_colname}}) |> pull()
     keynum <- key |> select({{num_colname}}) |> pull()

     # match the
     data_recode_var <- keystr[match(data_recode2, keynum)]
     dataset[, i]  <- data_recode_var

  }
  return(dataset)
}
