#' Sample dataset with missing values
#'
#' A sample dataset (`df_missing`) containing missing values in categorical numeric variables and an associated dictionary (`dict_df_missing`) that defines category labels, including indicators for missing and special cases.
#'
#' @format ## `df_missing`
#' A data frame with 10 rows and 5 columns:
#' \describe{
#'   \item{id}{Unique identifier for each record.}
#'   \item{gender}{Gender of the individual (factor: "Male", "Female").}
#'   \item{age}{Age.}
#'   \item{blood_pressure_category}{Blood pressure category (numeric; includes codes for missing values).}
#'   \item{glucose_level}{Glucose level category (numeric).}
#'   \item{cholesterol_level}{Cholesterol level category (numeric; includes codes for missing values).}
#' }
#' @source Generated as an example dataset.
"df_missing"

#' Dictionary for categorical numeric variables including missing values
#'
#' @format ## `dict_df_missing`
#' A data frame with category labels for `df_missing`, including missing and special value indicators, with 15 rows and 4 columns:
#' \describe{
#'   \item{variable}{Name of the variable (e.g., "blood_pressure_category").}
#'   \item{level_num}{Numeric level representing each category, with special codes for missing values (e.g., -9999 for "Missing").}
#'   \item{level_str}{String label for each numeric level (e.g., "Normal", "Elevated", "Missing").}
#'   \item{missing}{Indicator for missing values (1 = missing, 0 = not missing).}
#' }
#'
#' @source Generated as an example dataset.
"dict_df_missing"
