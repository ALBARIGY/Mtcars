

#Part 1; Data Mgt And Structure
# EX1; Explore the data

# Loading the data

data("mtcars")
df <- mtcars

# (a) Opening the dataset in a viewer window
View(df) 

# (b) Print the first six row to the console
head(df, 6) 

# (c) Extract mpg using the dollar sign($)

mpg <- df$mpg

# (d) Print the single value at row 4, column 3 using [,]. 

print(df[4,3])

# Then select rows 1 - 5 and column mpg and wt

print(df[1:5, c(1,6)])


# EX2; Check and Convert Types

# (a) Checking whether mpg is numeric and am is logical

is.numeric(df$mpg) # yes it is true
is.logical(df$am) # No it is not logical

# (b) Converting cyl to character

df$cyl <- as.character(df$cyl)

# (c) Converting cyl back to numeric

df$cyl <- as.numeric(df$cyl)


# (d) Creating objects x and y then removing both in a single line

x <- 10
y <- "Hello"

rm(x,y)


#Part 2; Data manipulation - Dplyr
library(tidyverse)

data("airquality")

aq <- airquality


# EX3 Select, rename and slice

# (a) Using a pipe operator to select multiple columns

seleted_columns <- aq %>% select(Ozone, Wind, Temp, Month)

# (b) Chaining a rename step

chained_step <- aq %>% select(Ozone, Wind, Temp, Month) %>% rename(temperature = Temp, wind_speed = Wind) 


# (c) Chaining the final step returning only rows 5 through 15

chained_final_step <- aq %>% select(Ozone, Wind, Temp, Month) %>% 
  rename(temperature = Temp, wind_speed = Wind) %>% 
  slice(5:15)

# EX4 Filter, Mutate and summarize

# (a) Filtering for days in month 7&8 where Ozone > 40

aq %>% filter(Ozone > 40, Month %in% c(7,8))

