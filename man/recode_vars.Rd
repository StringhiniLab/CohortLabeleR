% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/recode_vars.R
\name{recode_vars}
\alias{recode_vars}
\title{Recode all numeric codes in a data frame to categorical labels
using a dictionary}
\usage{
recode_vars(
  dataset,
  dictionary,
  ignore_columns,
  var_colname,
  num_colname,
  str_colname
)
}
\arguments{
\item{dataset}{Any data frame with categorical variables coded as numbers.}

\item{dictionary}{A data frame that serves as a dictionary,
mapping each numeric code to its corresponding category string.}

\item{ignore_columns}{You don't want to modify the columns that
serves as the id of the data or numeric variables
that are not categorical variables. You can specify them here.}

\item{var_colname}{Name of the dictionary column containing the
dataset variable names. To understand the dataset format,
 refer to the documentation for the `dict_df` dataset.}

\item{num_colname}{Name of the dictionary column containing
the numeric codes for the categories. To understand the dataset format,
refer to the documentation for the `dict_df` dataset.}

\item{str_colname}{Name of the dictionary column containing the
labels or categories as character strings. To understand the dataset
format, refer to the documentation for the `dict_df` dataset.}
}
\value{
A data frame identical to the original dataset,
but with numeric category values replaced by
their corresponding label in the specified columns.
}
\description{
Categorical variables are often entered in databases as numbers,
with each number representing a specific category.
Which category corresponds to each number
is typically coded in the dictionary.

This function allows you to replace ALL the
numeric values representing categories with
the associated string in a data frame.
This functionality can be particularly useful
when plotting multiple variables at once,
as it avoids the need to manually replace axis labels
for each plot.
}
\examples{
recode_vars(data = df,
            ignore_columns = c(id, age),
            dictionary = dict_df,
            var_colname = variable,
            num_colname = level_num,
            str_colname = level_str)
}
