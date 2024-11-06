#' Add labels readable by STATA to all the columns automatically
#'
#' @return
#' @export
#'
#' @examples
add_labels_STATA_df <- function(){

  # ADD LABELS
  # Small dataset to assign the names to the variable code
  dictionary <- dict_base_fp1_fp2 |>
    select(name, label_question)
  # write.csv(dictionary, "data/dictionary.csv")
  dict_study <- dictionary |> filter(name %in% colnames(base_fp1_fp2))

  dict_study <- dict_study[!duplicated(dict_study), ]

  missing_vars <- tibble(
    name = c(setdiff(colnames(base_fp1_fp2), dict_study$name)),
    label_question = "")

  dict_study <- dict_study |> rbind(missing_vars)

  #  Assign the labels to the corresponding columns in df
  for (i in 1:nrow(dict_study)) {

    #  if(names(dataset) %in% dictionary$name[i])) next

    col_name <- as.character(dict_study$name[i])
    label <- as.character(dict_study$label_question[i])
    attr(base_fp1_fp2[[col_name]], "label") <- label
  }

  haven::write_dta(base_fp1_fp2, "data/data_base_fp1_fp2_labels.dta")

}
