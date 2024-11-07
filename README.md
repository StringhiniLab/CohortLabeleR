
<!-- README.md is generated from README.Rmd. Please edit that file -->

# STATAtransfer

<!-- badges: start -->
<!-- badges: end -->

STATAtransfer provides functions to easily add STATA-style variable and
cell labels to entire datasets in R. It also includes tools for quick
variable recoding, making it easier to work with labeled data and
streamline workflows between STATA and R.

## Installation

You can install the development version of STATAtransfer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("StringhiniLab/STATAtransfer")
```

## Use

This package consists of three functions.

### 1. `recode_vars()`.

Many datasets, such as CLSA, use numeric codes for categorical
variables. This can make it harder to label axes when you want to
produce many plots or to interpret the data at a glance. This function
replaces all numeric category values in the data frame with their
corresponding labels, making the data easier to read and visualize. For
example, if we want to plot the last three variables of this dataset:

``` r
library(STATAtransfer)
library(dplyr)
library(ggplot2)
library(purrr)
head(df)
#>   id gender age blood_pressure_category glucose_level cholesterol_level
#> 1  1   Male  25                       1             1                 1
#> 2  2 Female  30                       2             4                 3
#> 3  3   Male  22                       1             1                 1
#> 4  4   Male  35                       3             3                 2
#> 5  5 Female  40                       1             1                 3
#> 6  6   Male  28                       4             4                 2
```

``` r

# Function for plotting
barplot <- function(var, data = df){
data |> 
count(!!sym(var)) |> 
ggplot(aes(x = !!sym(var), y = n)) +
  geom_col() + 
  coord_flip() +
  theme_minimal()
}

# I create plots for three variables
purrr::map(colnames(df)[4:6], barplot)
#> [[1]]
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

    #> 
    #> [[2]]

<img src="man/figures/README-unnamed-chunk-2-2.png" width="100%" />

    #> 
    #> [[3]]

<img src="man/figures/README-unnamed-chunk-2-3.png" width="100%" /> The
category levels of each variable are not possible to recognize. To fix
this, you can use `recode_vars` to replace the labels directly, using
the dictionary as a reference.

``` r
# dictionary
head(dict_df)
#>                  variable level_num            level_str
#> 1 blood_pressure_category         1               Normal
#> 2 blood_pressure_category         2             Elevated
#> 3 blood_pressure_category         3 Hypertension Stage 1
#> 4 blood_pressure_category         4 Hypertension Stage 2
#> 5           glucose_level         1                  Low
#> 6           glucose_level         2               Normal

# recoding the variables
df_recoded <- recode_vars(data = df,
            # specify here other numeric columns you would like to ignore
            ignore_columns = c(id, age), 
            dictionary = dict_df,
            # dictionary column with the variable names
            var_colname = variable, # dictionary column with the variables
            # dictionary column with the category numbers
            num_colname = level_num,
            # dictionary column with the category labels
            str_colname = level_str)
head(df_recoded)
#>   id gender age blood_pressure_category glucose_level cholesterol_level
#> 1  1   Male  25                  Normal           Low         Desirable
#> 2  2 Female  30                Elevated          High              High
#> 3  3   Male  22                  Normal           Low         Desirable
#> 4  4   Male  35    Hypertension Stage 1  Pre-diabetes        Borderline
#> 5  5 Female  40                  Normal           Low              High
#> 6  6   Male  28    Hypertension Stage 2          High        Borderline
```

``` r
purrr::map(data = df_recoded, colnames(df_recoded)[4:6], barplot)
#> [[1]]
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

    #> 
    #> [[2]]

<img src="man/figures/README-unnamed-chunk-4-2.png" width="100%" />

    #> 
    #> [[3]]

<img src="man/figures/README-unnamed-chunk-4-3.png" width="100%" />

### 2. `replace_missing_with_na()`

This function reads the dictionary and detects observations that are
coded as missing. These missing values are represented numerically, with
values like -99, which are clearly not valid results.

Databases such as CLSA, encode these missing values distinguishing the
reasons for the missing data and assigning different numeric codes to
each case. It is not the same to say that the person preferred not to
answer the survey as it is to say that the survey was never conducted.
This means that there are many numeric codes that can represent a
missing value.

The goal of this function is to convert all of the missing values of the
categorical variables coded as numbers of a data frame to `NA`. This
makes it much easier to detect the total amount of missing data per
variable, regardless of the origin of the missing values.

``` r
# There are missing values in blood_pressure_category and cholesterol_level
df_missing
#>    id gender age blood_pressure_category glucose_level cholesterol_level
#> 1   1   Male  25                       1             1                 1
#> 2   2 Female  30                       2             4                 3
#> 3   3   Male  22                       1             2             -9999
#> 4   4   Male  35                       3             3                 2
#> 5   5 Female  40                       1             1                 3
#> 6   6   Male  28                       4             4                 2
#> 7   7 Female  32                       1             1                 1
#> 8   8   Male  27                       2             1                 1
#> 9   9 Female  45                   -9999             4                 3
#> 10 10   Male  29                       1             1             -8888
```

``` r
df_missing_NA <-  replace_missing_with_na(dataset = df_missing,
                         ignore_columns = c(id, age),
                         dictionary = dict_df_missing,
                         var_colname = variable,
                         num_colname = level_num,
                         missing_colname = missing)

df_missing_NA
#>    id gender age blood_pressure_category glucose_level cholesterol_level
#> 1   1   Male  25                       1             1                 1
#> 2   2 Female  30                       2             4                 3
#> 3   3   Male  22                       1             2                NA
#> 4   4   Male  35                       3             3                 2
#> 5   5 Female  40                       1             1                 3
#> 6   6   Male  28                       4             4                 2
#> 7   7 Female  32                       1             1                 1
#> 8   8   Male  27                       2             1                 1
#> 9   9 Female  45                      NA             4                 3
#> 10 10   Male  29                       1             1                NA
```

Now, let’s estimate the percentage of data that is missing.

``` r
# 2 of 10 observations are missing for cholesterol_level (20%)
# 1 of 10 observations are missing for blood_pressure_category (10%)
colMeans(is.na.data.frame(df_missing_NA))*100
#>                      id                  gender                     age 
#>                       0                       0                       0 
#> blood_pressure_category           glucose_level       cholesterol_level 
#>                      10                       0                      20
```
