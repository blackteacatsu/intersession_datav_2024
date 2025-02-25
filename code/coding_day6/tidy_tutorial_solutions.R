#### SETUP ####
getwd()
setwd('/Users/kalenclifton/intersession_data_2024/code/coding_day6/')


install.packages("tidyverse")
install.packages("nycflights13")

library(tidyverse)
library(nycflights13)

#### DATA ####
flights #tibble: type of dataframe for tidyverse
View(flights)
print(flights, width = Inf)
glimpse(flights)

#### DATA MANIPULATION ####
##### dplyr functions #####
# 1. The first argument is always a data frame.
# 2. The subsequent arguments typically describe which columns to operate on, 
#     using the variable names (without quotes).
# 3. The output is always a new data frame.
# Because each function does one thing well, solving complex problems will 
# usually require combining multiple verbs, and we’ll do so with the pipe 

##### pipe #####
# |> or %>%
# takes the thing on its left and passes it along to the function on its right
# pronounce the pipe as “then”
# Ctrl/Cmd + Shift + M

#three equivalent methods
flights1 <- filter(flights, dest == "IAH")
flights2 <- group_by(flights1, year, month, day)
flights2

group_by(
  filter(
    flights, 
    dest == "IAH"
  ),
  year, month, day
)

flights %>% 
  filter(dest == "IAH") %>%  
  group_by(year, month, day)

#### ROWS ####
##### filter() #####
#   - changes which rows are present without changing their order
#   - allows you to keep rows based on the values of the columns
#   - arguments are the conditions that must be true to keep the row

# find all flights that departed more than 120 minutes (two hours) late
flights %>% 
  filter(dep_delay > 120)

# Flights that departed on January 1
flights %>% 
  filter(month == 1 & day == 1)

# Flights that departed in January or February
flights %>% 
  filter(month == 1 | month == 2)

# A shorter way to select flights that departed in January or February
flights %>% 
  filter(month %in% c(1, 2))

# to save result use the assignment operator <- to assign to variable
jan1 <- flights %>% 
  filter(month == 1 & day == 1)

##### arrange() #####
#   - changes the order of the rows without changing which are present
#   - arguments are set of column names (or more complicated expressions) to order by
#   - default to order in ascending order
#   - give more column names to break ties in preceding columns
#   - use desc() on a column inside of arrange() to re-order the data descending 

flights %>% 
  arrange(year, month, day, dep_time)

flights %>% 
  arrange(desc(dep_delay))

#### COLUMNS ####

##### mutate() #####
#   - add new columns that are calculated from the existing columns

# compute gain, how much time a delayed flight made up in the air
# compute speed in mph
flights %>% 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )

# use the .before argument to instead add the variables to the left hand side
flights %>% 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

# can also use .after to add after a variable
# in both .before and .after you can use the variable name instead of a position
flights %>% 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

# can control which variables are kept with the .keep argument
#"used" specifies only keep the columns involved or created in the mutate() step

delay_gain <- flights %>% 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )

##### select() #####
#   - subset using operations based on the names of the variables

# Select columns by name
flights %>% 
  select(year, month, day)

#Select all columns between year and day
flights %>% 
  select(year:day)

#rename variables as you select() them by using =
# new name appears on the left hand side of the =
# old variable appears on the right hand side

flights %>% 
  select(tail_num = tailnum)

##### rename() #####
# keep all the existing variables and just want to rename a few 
# use rename() instead of select()

flights %>% 
  rename(tail_num = tailnum) %>% 
  glimpse()

#### GROUPS ####

##### group_by() #####
# - Use group_by() to divide dataset into groups meaningful for your analysis
# - doesn't change data but output indicates "grouped by" 
#   and subsequent operations will now work on this group

flights %>% 
  group_by(month)

##### Summarize() #####
# - most important group operation
# - if being used to calculate a single summary statistic,
#   reduces the data frame to have a single row for each group

flights %>% 
  group_by(month) %>% 
  summarize(
    avg_delay = mean(dep_delay)
  )

flights %>% 
  group_by(month) %>% 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )

# create any number of summaries in a single call to summarize()
flights %>% 
  group_by(month) %>% 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()
  )

# create groups using more than one variable
daily_flights<- flights %>%  
  group_by(year, month, day) %>% 
  summarize(n= n(),
            .groups = "keep"
  )
daily_flights

#### REFERENCE ####
# https://r4ds.hadley.nz/data-transform

#try exercises 3.2.5.1, 3.2.5.2, 3.5.6.2, 3.5.7.3 

#exercise 3.2.5.1

#Had an arrival delay of two or more hours
flights %>% 
  filter(arr_delay >= 120)

flights %>% 
  filter(dest %in% c("IAH","HOU"))

flights %>% 
  filter(carrier %in% c("UA", "AA", "DL"))

flights %>% 
  filter(month %in% c(7,8,9))

flights %>% 
  filter(arr_delay >= 120, dep_delay <= 0)

flights %>% 
  mutate(
    gain = dep_delay - arr_delay,
    .after = day) %>% 
  filter(dep_delay >= 60, gain > 30)

#exercise 3.2.5.2


