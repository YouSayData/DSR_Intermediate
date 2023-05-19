# 1. Functions ------------------------------------------------------------

# You can extend R with your own functions

minus_1 <- function(input_parameter) {
  # body
  result <- input_parameter - 1
  # return 
  return(result)
}

minus_1(5)

# R has an implicit return and
# if your function is a onliner you don't need {}

minus_2 <- function(input_parameter) input_parameter - 2

minus_2(5)

# Handy returns -----------------------------------------------------------
minus_2("5") 

minus_3 <- function(input_parameter) {
  if (typeof(input_parameter) == "character") {
    warning("Character was given to function; I am trying to extract a number.")
    input_parameter <- parse_number(input_parameter)
    if (is.na(input_parameter)) {
      stop("No number found!")
    } 
    message(cat("Found", input_parameter))
  }
  
  input_parameter - 3
}

minus_3("5")
minus_3("hello")

# 2. More common applications--------------------------------------------------------------

# normalise this tibble
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df

# one way of normalising would be 

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))

# where is the mistake?
# if you run a code more than once, it is better to write a function!

x <- df$a
(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

# double calculations can be expensive
rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])

# let's put it into a function
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(c(1, 6, 11))
rescale01(c(-10, 0, 10))
rescale01(c(1, 2, 3, NA, 5))

# let's start again

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

(df_normalised <-df %>% mutate_all(rescale01))

# still some problems
x <- c(1:10, Inf)
rescale01(x)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(x)

# Exercises
# 1. In the second variant of rescale01(), infinite values are left unchanged. 
#    Rewrite rescale01() so that -Inf is mapped to 0, and Inf is mapped to 1.
# 2. Write both_na(), a function that takes two vectors of the same length and 
#    returns the number of positions that have an NA in both vectors.
# 3. Think of the song "99 bottles of beer on the wall", write a function that for
#    an x returns "[x] bottles of beer on the wall, [x] bottles of beer."
#    "If one of those bottles should happen to fall, [x - 1] bottles of beer on the wall."
#    What cases do you have to care for?