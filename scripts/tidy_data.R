# 0. Libraries needed -----------------------------------------------------

library(tidyverse)

# 1. Tidy Data ---------------------------------------------------------------

# What is the difference between those tibbles what are the similarities?

table1
table2
table3
table4a
table4b

# Tidy Rules -------------------------------------------------------------------

# 1. Each variable must have its own column.
# 2. Each observation must have its own row.
# 3. Each value must have its own cell.

# This means: 
# 1. Put each dataset in a tibble.
# 2. Put each variable in a column.

# Reasons for Tidy Data ------------------------------------------------

# Compute rate per 10,000
table1 |> 
  mutate(rate = cases / population * 10000)

# Compute cases per year
table1 |>  
  count(year, wt = cases)

# Visualise changes over time
table1 |> 
  ggplot(aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))


# 1.1. Exercise -----------------------------------------------------------

# Compute the rate for table2, and table4a + table4b.
# Discuss how you can achieve this.
# Which table is the easiest to work with?

# Real World Problems -----------------------------------------------------

# 1. One variable might be spread across multiple columns.
# 2. One observation might be scattered across multiple rows.

# Pivoting ----------------------------------------------------------------
# Making data longer or wider

# pivot_longer()

table4a

table4a |>
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

table4b  |>  
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

# full Transformation

tidy4a_t <- table4a |> 
  pivot_longer(c(`1999`, `2000`), 
               names_to = "year", 
               values_to = "cases", 
               names_transform = list(year = as.integer))
tidy4b_t <- table4b |> 
  pivot_longer(c(`1999`, `2000`), 
               names_to = "year", 
               values_to = "population", 
               names_transform = list(year = as.integer))
left_join(tidy4a_t, tidy4b_t)

# pivot_wider()

table2

table2 |>
  pivot_wider(names_from = type, values_from = count)


# 1.2. Exercise -----------------------------------------------------------

# 1. Tidy this dataset

billboard

# Separating out values or uniting them -----------------------------------

# Separate ----------------------------------------------------------------

table3

# start
table3 |> 
  separate(rate, into = c("cases", "population"))

# better
table3 |> 
  separate(rate, into = c("cases", "population"), convert = TRUE)

# separate wider is now a bit more verbose
table3 |> 
  separate_wider_delim(rate, delim = "/", names = c("cases", "population"))

table3 |> 
  separate_wider_regex(rate, pattern = c(cases = "\\d+", "/", population = "\\d+"))


# Unite -------------------------------------------------------------------

table5

table5 |> 
  unite(new, century, year)

table5 |> 
  unite(new, century, year, sep = "") |>
  mutate(year = as.integer(new)) |>
  select(-new)


# 1.3 Exercise ------------------------------------------------------------

# What do the extra and fill arguments do in separate()? Experiment with the various options for the following two toy datasets.

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) |> 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) |> 
  separate(x, c("one", "two", "three"))
