#' This function removes missing values for numeric columns
#' based on the dictionary code
#'
#' @param dataset
#' @param dictionary
#'
#' @return
#' @export
#'
#' @examples
remove_missing_data_numeric_cols <- function(dataset, dictionary) {

  # Extract column names type double
  vars_double <- dataset |>
    select(where( ~ is.double(.)),
           -entity_id) |> colnames()

  data <- c()
  for (i in vars_double) {
    var <- dataset[, i] |> pull()

    dict <- dictionary |>
      filter(name == i)

    if(!any(dict$missing == 1) | all(is.na(dict$missing))) next

    # replace the missing value with NA
    var[var %in% as.double(dict$name_axis)] <- NA

    dataset[, i] <- var

  }
  return(dataset)
}
