#' Recode variables
#'
#' @description
#'
#'
#' @param dataset
#' @param dictionary
#'
#' @return
#' @export
#'
#' @examples
recode_vars <- function(dataset, dictionary) {
  # selection of variables that need factor categories label replacement
  data_recode <-  dataset |>
    select(where( ~ !is.double(.)),-entity_id)

  vars_recode <- colnames(data_recode)

  data_recode_complete <- c()
  for (i in vars_recode) {

    # the variables added as extra should not be considered
    if (!(i %in% dictionary$name))
      next
    # this variable is only in the baseline study
    if(i == 'AGE_NMBR_COM') next

    key <-  dictionary |>
      filter(name == i) |>
      select(name_axis, label_axis)

    # to use the function match, better convert all to character
    data_recode2 <- data_recode[, i] |>
      mutate(across(all_of(i), as.character)) |>
      pull()
    key$name_axis <- as.character(key$name_axis)

    # select the correct labels
    data_recode_var <- key$label_axis[match(data_recode2,
                                            key$name_axis)]
    dataset[, i]  <- data_recode_var

  }
  return(dataset)
}
