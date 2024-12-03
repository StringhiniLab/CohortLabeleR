#' Title
#'
#' @param var Variable
#' @param dataset Dataset
#' @param dictionary Dictionary
#'
#' @return Plot
#' @export
#'
#' @examples
boxplot_barplot <- function(var, dataset, dictionary){

  # there are different plots if the variable is continuous or categorical
  if(is.double(dataset[, as.character({{var}})])){


    print(dictionary)
    dataset |>
      #filter(!str_detect({{var}}, 'DO NOT READ')) |>
      ggplot(aes(y = {{var}}, x = "var")) +
      geom_flat_violin(position = position_nudge(x = .2),
                       alpha = 0.7,
                       adjust = 0.5) +
      geom_point(alpha = 0.1,
                 position = position_jitter(w = .15)) +
      geom_boxplot(width = .25) +
      # geom_jitter(alpha = 0.2, color = 'aquamarine4') +
      # geom_boxplot(fill = 'transparent') +
      xlab(dictionary$label_question[dictionary$name == as.character(var)]) +
      theme_minimal() +
      theme(
        axis.title.x = element_text(size = 11), # I have to add this if not fonts disappear from screen
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.title = element_text(size = 11),
        legend.text = element_text(size = 10)
      )


  }else{


    # There is an issue using tidyevaluation and ggplot
    dataset |>
      #  filter(!str_detect({{var}}, 'DO NOT READ')) |>
      ggplot(aes(x = fct_reorder(as.factor({{var}}),
                                 as.factor({{var}}), .fun = 'length'))) +
      geom_bar() +
      scale_x_discrete() +
      xlab(dictionary$label_question[dictionary$name == as.character(var)]) +
      coord_flip() +
      theme_minimal() +
      theme(
        # plot.title = element_text(size = 11),
        axis.title.x = element_text(size = 11), axis.text.x = element_text(size = 10),
        # , axis.title.y = element_text(size = 11) # seems so-so similar as default, i.e. without this line.
        axis.text.y = element_text(size = 10), # appears, and not too small.
        # , axis.text.y = element_text(size = 9) # appears even on external monitor when on Chrome.
        # , axis.text.y = element_text(size = 8) # disappears on external monitor when on Chrome, but appear on laptop monitor or on Safari/Firefox.
        legend.title = element_text(size = 11),
        legend.text = element_text(size = 10)  # without this line, disappears on external monitor when on Chrome
      )

  }
}

#' Title
#'
#' @param dataset
#' @param dictionary
#' @param var
#'
#' @return
#' @export
#'
#' @examples
scatter_or_area <- function(dataset, dictionary, var){

  if(is.double(dataset[, as.character(var)])){

    # AGE_NMBR_COM is only reported in the baseline study
    var_age <-  "AGE_NMBR_COM"
    var_age_group <- "AGE_GRP_COM"


    dataset |>
      filter(!str_detect(get(var), 'DO NOT READ')) |>
      ggplot(aes(x = .data[[var_age_group]],
                 y = get(var), group = .data[[var_age_group]]))+
      geom_flat_violin(position = position_nudge(x = .2),
                       alpha = 0.7,
                       adjust = 0.5) +
      geom_point(alpha = 0.1,
                 position = position_jitter(w = .15)) +
      geom_boxplot(width = .25) +
      #geom_jitter(alpha = 0.1) +
      # geom_boxplot(color = 'blue') +
      # geom_point(alpha = 0.2) +
      # geom_smooth(se = TRUE)+
      ylab(dictionary$label_question[dictionary$name == as.character(var)]) +
      xlab("Age (years)") +
      theme_minimal() +
      theme(
        axis.title.x = element_text(size = 11),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.title = element_text(size = 11),
        legend.text = element_text(size = 10)
      )



  }else{

    # AGE_NMBR_COM is only reported in the baseline study
    var_age <-  "AGE_NMBR_COM"

    dataset |>
      filter(!str_detect(get(var), 'DO NOT READ')) |>
      dplyr::count(.data[[var]], .data[[var_age]]) |>
      dplyr::arrange(desc(n)) |>
      ggplot(aes(x = .data[[var_age]],
                 y= n,
                 fill = as.factor(.data[[var]]))) +
      geom_area() +
      ylab(dictionary$label_question[dictionary$name == as.character(var)]) +
      xlab("Age (years)") +
      theme_minimal() +
      theme(
        axis.title.x = element_text(size = 11),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.title = element_text(size = 11),
        legend.text = element_text(size = 10)
      )

  }}


#' Title
#'
#' @param dataset
#' @param dictionary
#' @param var
#'
#' @return
#' @export
#'
#' @examples
statsplot_or_table <- function(dataset, dictionary, var){

  if(is.double(dataset[, as.character(var)])){

    data <- dataset[,.data[[var]]]
    kurtosis <- moments::kurtosis(data, na.rm = TRUE)
    skewness <- moments::skewness(data, na.rm = TRUE)
    median1 <- median(data, na.rm = TRUE)
    mean1 <- mean(data, na.rm = TRUE)

    ggplot(data, aes(x = .data[[var]])) +
      geom_histogram(binwidth = 0.5,
                     alpha=0.5,
                     position="identity",
                     aes(y = ..density..)) +
      geom_vline(aes(xintercept=mean(.data[[var]],
                                     na.rm = TRUE)),
                 color="red",
                 linetype="dashed", size=0.5) +
      geom_vline(aes(xintercept=median(.data[[var]],
                                       na.rm = TRUE)),
                 color="orange",
                 linetype="dashed", size=0.5) +
      geom_density(alpha=.2,
                   color = "#FF6666",
                   fill="#FF6666") +
      theme_minimal() +
      ggtitle(paste("Kurtosis:", round(kurtosis, 2),
                    " Skewness:", round(skewness, 2),
                    "\nMedian:", round(median1, 2),
                    " Mean:", round(mean1, 2)))
  }else{

    library(DT)

    dataset |>
      # filter(!str_detect(.data[[varsel()]], 'DO NOT READ')) |>
      count(.data[[var]]) |>
      mutate(Percentage = round((n / sum(n) * 100), digits = 2)) |>
      arrange(desc(n)) |>
      datatable(
        options = list(
          searching = FALSE,  # Remove search bar
          paging = FALSE,     # Remove pagination
          info = FALSE        # Remove footer information
        ))
  }
}
