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


#### ROWS ####
##### filter() #####
#   - changes which rows are present without changing their order
#   - allows you to keep rows based on the values of the columns
#   - arguments are the conditions that must be true to keep the row

## find all flights that departed more than 120 minutes (two hours) late

# Filter flights that departed more than 120 minutes late
delayed_flights <- flights %>%
  filter(dep_delay > 120) # dep_delay in minutes units 

# View the result
head(delayed_flights)
nrow(delayed_flights) # the number of flights that departed for over 2 hrs late 

# Flights that departed on January 1
new_year_flights <- flights %>% 
  filter(month == 1 & day == 1) 

head(new_year_flights)
nrow(new_year_flights) # 842 flights departed on January 1 

# Flights that departed in January or February
jan_or_feb_flights <- flights %>%
  filter(month == 1 | month ==2)

nrow(jan_or_feb_flights) # 51955 flights departed in Jan or Feb 
head(jan_or_feb_flights)

# A shorter way to select flights that departed in January or February
# Shorter way to filter for flights departing in January or February
jan_or_feb_flights <- flights %>%
  filter(month %in% c(1, 2))

# View the result
nrow(jan_or_feb_flights)  # Number of flights departed in Jan or Feb 
head(jan_or_feb_flights) # same as previous method 

# to save result use the assignment operator <- to assign to variable


##### arrange() #####
#   - changes the order of the rows without changing which are present
#   - arguments are set of column names (or more complicated expressions) to order by
#   - default to order in ascending order
#   - give more column names to break ties in preceding columns
#   - use desc() on a column inside of arrange() to re-order the data descending 

flights %>% 
  arrange(year, month, day, dep_time, arr_time)

#### COLUMNS ####

##### mutate() #####
#   - add new columns that are calculated from the existing columns

# compute gain, how much time a delayed flight made up in the air
flights_with_gain <- flights %>% 
  mutate(
    gain = (arr_time - dep_time) / 60 # in hours 
  )
# compute speed in mph
flights_with_speed <- flights_with_gain %>%
  mutate(
    speed = distance / gain # in mph 
  )

# use the .before argument to instead add the variables to the left hand side
flights_with_speed <- flights_with_gain %>%
  mutate(
    speed = distance / gain # in mph 
  )

# can also use .after to add after a variable
# in both .before and .after you can use the variable name instead of a position


# can control which variables are kept with the .keep argument
#"used" specifies only keep the columns involved or created in the mutate() step



##### select() #####
#   - subset using operations based on the names of the variables

# Select columns by name


#Select all columns between year and day


#rename variables as you select() them by using =
# new name appears on the left hand side of the =
# old variable appears on the right hand side



##### rename() #####
# keep all the existing variables and just want to rename a few 
# use rename() instead of select()



#### GROUPS ####

##### group_by() #####
# - Use group_by() to divide dataset into groups meaningful for your analysis
# - doesn't change data but output indicates "grouped by" 
#   and subsequent operations will now work on this group



##### Summarize() #####
# - most important group operation
# - if being used to calculate a single summary statistic,
#   reduces the data frame to have a single row for each group





# create any number of summaries in a single call to summarize()


# create groups using more than one variable


#### REFERENCE ####
# https://r4ds.hadley.nz/data-transform

#try exercises 3.2.5.1, 3.2.5.2, 3.5.6.2, 3.5.7.3 

