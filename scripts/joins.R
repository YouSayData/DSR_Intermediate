
# I. Relational Data ---------------------------------------------------------

# When working with relational data, we look at three types of functions:

# 1. Mutating joins
# 2. Filtering joins
# 3. Set operations

# nycflights13 has more than just the flights data:

flights
skim(flights)
glimpse(flights)

airlines
airports
planes
weather

# flights connects to planes via a single variable, tailnum.
# flights connects to airlines through the carrier variable.
# flights connects to airports in two ways: via the origin and dest variables.
# flights connects to weather via origin (the location), and year, month, day and hour (the time).

# Variables used to connect the tables are called keys
# A primary key uniquely identifies an observation in its own table. For example, planes$tailnum is a primary key because it uniquely identifies each plane in the planes table.
# A foreign key uniquely identifies an observation in another table. For example, flights$tailnum is a foreign key because it appears in the flights table where it matches each flight to a unique plane.

# Once you’ve identified the primary keys in your tables, it’s good practice to verify that they do indeed uniquely identify each observation. One way to do that is to count() the primary keys and look for entries where n is greater than one:

planes |>
  count(tailnum) |>
  filter(n > 1)

weather |>
  count(year, month, day, hour, origin) |>
  filter(n > 1)

# Sometimes you need a surrogate key


# Question I -------------------------------------------------------------

# We know that some days of the year are “special”, and fewer people than usual fly on them. 
# How might you represent that data as a data frame? 
# What would be the primary keys of that table? How would it connect to the existing tables?


# Exercise I ---------------------------------------------------------------

# 1. Add a surrogate key to flights.
# 2. Is there a primary key in the diamonds dataset? If so, which is it?


# II. Mutating Joins ------------------------------------------------------

# Let's produce a smaller dataset
(flights2 <- flights |>
   select(year:day, hour, origin, dest, tailnum, carrier))

# If you want to enrich the flights2 table with information from another table data 
# you can do it like this:

flights2 %>%
  select(-origin, -dest) |>         # just to make it fit on the screen
  left_join(airlines, by = "carrier")

# It's called a mutating join, since you also could have used mutate():

flights2 %>%
  select(-origin, -dest) |>
  mutate(name = airlines$name[match(carrier, airlines$carrier)])


# Different kind of joins -------------------------------------------------

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

# in x and y inner_join()

x |>
  inner_join(y, by = "key")

# outer joins:
# left_join

x |>
  left_join(y, by = "key")

# right_join
x |>
  right_join(y, by = "key")

# full_join
x |>
  full_join(y, by = "key")


# Duplicate keys ----------------------------------------------------------

# one table has duplicate keys
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(x, y, by = "key")

# both tables have duplicate keys!

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")


# Implicit and explicit keys ----------------------------------------------

flights2 |>
  left_join(planes)

flights2 |>
  left_join(planes, by = "tailnum")

# different colnames

flights2 |>
  left_join(airports, c("dest" = "faa"))

flights2 |>
  left_join(airports, c("origin" = "faa"))


# Exercise II -------------------------------------------------------------


# 1. Add the location of the origin and destination (i.e. the lat and lon) to flights2 (don't save the result though).
# 2. Find out: Is there a relationship between the age of a plane and its delays?


# Filtering Joins ---------------------------------------------------------

# Filtering joins affect observations not variables

# semi_join(x, y) keeps all observations in x that have a match in y
# anti_join(x, y) drops all observations in x that have a match in y.

(top_dest <- flights %>%
   count(dest, sort = TRUE) %>%
   head(10))

# option A
flights |>
  filter(dest %in% top_dest$dest)

# option B
flights |>
  semi_join(top_dest)

# anti_join helps to see incomplete data

flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)


# Exercise III ------------------------------------------------------------

# 1. What does it mean for a flight to have a missing tailnum? What do the tail numbers that don’t have a matching record in planes have in common? (Hint: one variable explains ~90% of the problems.)
# 2. Filter flights to only show flights with planes that have flown at least 100 flights.
# 3. Find the 48 hours (over the course of the whole year) that have the worst delays. Cross-reference it with the weather data. Can you see any patterns?

# Recipe for working with relational data
# Data is often not cleaned!

# 1. Identify which variables form the primary key
# 2. Check that they do not contain NA
# 3. Use anti_join to look for data entry errors


# Set Operations ----------------------------------------------------------

df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)
df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

# Observations in both df1 and df2
intersect(df1, df2)

# All unique observations
union(df1, df2)

# Observations in df1 that are not in df2
setdiff(df1, df2)
