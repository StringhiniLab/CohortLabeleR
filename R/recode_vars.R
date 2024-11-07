#' Recode variables
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
#' @param id You don't want to recode the columns that
#' serves as the id of the data. You can specify them here.
#'
#' @return A data frame identical to `data`,
#' but with numeric category values replaced by
#' their corresponding string in the specified columns.
#'
#' @export
#'
#' @examples
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
# for(i in vars_recode){
#   # filtro el diccionario asi despues se va con el join
#   dict_sub <- dictionary |>
#     dplyr::filter({{var_colname}} == i) |>
#     select({{str_colname}}, {{num_colname}})
#
#   data_recode_complete <- dataset |>
#     left_join(dictionary, by = c({{i}} = {{num_colname}}))
#
# }
#

    c()
  # for (i in vars_recode) {
  #
   i = vars_recode[1]
     key <-  dictionary |>
       dplyr::filter({{var_colname}} == i) |>
       dplyr::select({{num_colname}},
                     {{str_colname}})
  #
  #   # to use the function match, better convert all to character
     data_recode2 <- data_recode[, i] #|>
      # dplyr::mutate(across(all_of(i), as.character)) |>
      # pull()

     # select the correct labels
     data_recode_var <- key$label_axis[match(data_recode2, key$name_axis)]
     dataset[, i]  <- data_recode_var
  #
  # }
 # return(dataset)
     return(data_recode2)
}
