
# Libraries ---------------------------------------------------------------

library(tidyverse)


# Loops -------------------------------------------------------------------

# Remember our tibble from functions.R
# Let's put the creation of it in a function itself

newData <- function() {
  tibble(
    a = rnorm(10),
    b = rnorm(10),
    c = rnorm(10),
    d = rnorm(10)
  )
}

# If we want to calculate the median for each column we could do
# it in multiple ways

# Four steps
df <- newData()
median(df$a)
median(df$b)
median(df$c)
median(df$d)

# This seems bulky. Let's use a for-loop instead

output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output


# Exercise I --------------------------------------------------------------

# Write loops for (Think about the output, sequence, and body before you start writing the loop.):
# 1. Compute the mean of every column in mtcars.
# 2. Determine the type of each column in nycflights13::flights.
# 3. Compute the number of unique values in each column of iris.
# 4. Generate 10 random normals from distributions with means of -10, 0, 10, and 100.


# Modifying an existing object with a for loop ----------------------------

df <- newData()
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}

# While Loop --------------------------------------------------------------

# Good for observing events in web development 
# or simulations

roleDice <- function() sample(1:6, 1)

playLotto <- function() sample(1:40, 6)
pickNumbers <- function() sample(1:40, 6)

weeks <- 1
hits <- 0
myNumbers <- pickNumbers()

while (hits < 5) {
  hits <- (myNumbers %in% playLotto()) %>% sum
  weeks <- weeks + .5
}
str_c("You got 5 hits after playing for over", 
      floor(weeks / 52), 
      "years.", sep = " ")


# Exercise II -------------------------------------------------------------

# 1. Write a function that prints the mean of each numeric column in a data frame, 
# along with its name. Test it on the iris data set.


# purrr maps --------------------------------------------------------------

# map() makes a list.
# map_lgl() makes a logical vector.
# map_int() makes an integer vector.
# map_dbl() makes a double vector.
# map_chr() makes a character vector.

df <- newData()

map_dbl(df, mean)
map_dbl(df, median)
map_dbl(df, sd)

# Or in a pipe
df %>% map_dbl(mean)

df$a[2] <- NA
df
df %>% map_dbl(mean)
map_dbl(df, mean, na.rm = T)



# Shortcuts ---------------------------------------------------------------

# this is verbose
mod_coef <- mtcars %>% 
  split(.$cyl) %>% 
  map(function(df) lm(mpg ~ wt, data = df)) %>%
  map(coef)

# less verbose
mod_coef <- mtcars %>% 
  split(.$cyl) %>% 
  map(~lm(mpg ~ wt, data = .)) %>%
  map(coef)


# Exercises ---------------------------------------------------------------

# Write code that uses one of the map functions to:

# 1. Compute the mean of every column in mtcars.
# 2. Determine the type of each column in nycflights13::flights.
# 3. Compute the number of unique values in each column of iris.
# 4. Generate 10 random normals from distributions with means of -10, 0, 10, and 100.
