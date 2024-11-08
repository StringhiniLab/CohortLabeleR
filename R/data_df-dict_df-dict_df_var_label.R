#' Sample dataset
#'
#' A sample dataset (`df`)
#'
#' @format ## `df`
#' A data frame with 10 rows and 5 columns:
#' \describe{
#'   \item{id}{Unique identifier for each record.}
#'   \item{gender}{Gender of the individual (factor: "Male", "Female").}
#'   \item{age}{Age in years (numeric).}
#'   \item{blood_pressure_category}{Blood pressure category (1 = "Normal", 2 = "Elevated", 3 = "Hypertension Stage 1", 4 = "Hypertension Stage 2").}
#'   \item{glucose_level}{Glucose level category (1 = "Low", 2 = "Normal", 3 = "Pre-diabetes", 4 = "High").}
#'   \item{cholesterol_level}{Cholesterol level category (1 = "Desirable", 2 = "Borderline", 3 = "High").}
#' }
#' @source Generated as an example dataset.
"df"



#' Dictionary for categorical numeric variables
#'
#' @format ## `dict_df`
#' A data frame that provides labels for categorical numeric variables in `df`, with 11 rows and 3 columns:
#' \describe{
#'   \item{variable}{Name of the variable (e.g., "blood_pressure_category").}
#'   \item{level_num}{Numeric level representing each category.}
#'   \item{level_str}{String label for each numeric level (e.g., "Normal", "Elevated").}
#' }
#' @source Generated as an example dataset.
"dict_df"


#' Dictionary data frames including variable labels and code labels
#'
#' @format ## `dict_df_var_label`
#' A data frame with variable labels for `df`, with 13 rows and 4 columns:
#' \describe{
#'   \item{variable}{Variable name (e.g., "gender", "age").}
#'   \item{level_num}{Numeric level associated with categorical variables (if applicable).}
#'   \item{level_str}{String representation of the level for categorical variables.}
#'   \item{var_label}{Label describing each variable (e.g., "Gender", "Age (years)").}
#' }
#' @source Generated as an example dataset.
"dict_df_var_label"
