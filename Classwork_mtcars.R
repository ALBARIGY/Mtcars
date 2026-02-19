

###################### Part 1: Data Management And Structure ##################

##### EX1 Explore the data #####

# Loading the data

data("mtcars")
df <- mtcars

# (a) Opening the dataset in a viewer window
View(df) 

# (b) Printing the first six row to the console
head(df, 6) 

# (c) Extracting mpg using the dollar sign($)

mpg <- df$mpg

# (d) Printing the single value at row 4, column 3 using [,]. 

print(df[4,3])

# Then selecting rows 1 - 5 and column mpg and wt

print(df[1:5, c(1,6)])




##### EX2 Check and Convert Types #####

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





###################### Part 2: Data manipulation - Dplyr ######################

library(tidyverse)

data("airquality")

aq <- airquality


##### EX3 Select, Rename and Slice #####

# (a) Using a pipe operator to select multiple columns

seleted_columns <- aq %>% select(Ozone, Wind, Temp, Month)

# (b) Chaining a rename step

chained_step <- aq %>% select(Ozone, Wind, Temp, Month) %>% rename(temperature = Temp, wind_speed = Wind) 


# (c) Chaining the final step returning only rows 5 through 15

chained_final_step <- aq %>% select(Ozone, Wind, Temp, Month) %>% 
  rename(temperature = Temp, wind_speed = Wind) %>% 
  slice(5:15)




##### EX4 Filter, Mutate and Summarize #####

# (a) Filtering for days in month 7&8 where Ozone > 40

aq %>% filter(Ozone > 40, Month %in% c(7,8))


# (b) Adding a column temp_celsius using: (Temp - 32) * 5 / 9

aq %>% mutate(temp_celsius = (Temp - 32) * 5 / 9)

# (c) Grouping by Month and calculate the mean Ozone per month, ignoring missing values.

aq %>%  group_by(Month) %>% summarise(ozone_mean = mean(Ozone, na.rm = TRUE))





#################### Part 3: Descriptive Statistics ########################

library(psych)


##### EX5 Summarize and Describe #####

# (a) Getting the full summary() of iris, then a summary of just Sepal.Length

data("iris")

ir <- iris

summary(ir)

summary(ir$Sepal.Length)


# b.Running describe() on iris and compare its output to summary() — what extra information does it give you?

describe(ir) # Extra informations are Variable index, number of observation, standard deviation, mean after 

# removing extreme values, median absolute deviation, skewness, kurtosis and standard error.






######################## Part 4: Statistical Tests ############################

##### EX6 T-Tests #####

# (a) Dataset: airquality; Testing whether the mean Wind speed is significantly different from 10 mph

t.test(aq$Wind, mu = 10)


# (b) Dataset: iris; Testing whether mean Sepal.Length differs between setosa and versicolor.

setosa <- ir[ir$Species == "setosa",]
versicolor <- ir[ir$Species == "versicolor",]

t.test(setosa$Sepal.Length, versicolor$Sepal.Length)


# (c)Dataset: sleep;The same 10 patients were tested under two drugs (group). 
# Testing whether extra sleep (extra) changed significantly between conditions.

data(sleep)
sl <- sleep

treatment1 <- sl[sl$group == "1",]
treatment2 <- sl[sl$group == "2",]

t.test(treatment1$extra, treatment2$extra)




##### EX7 Chi-Square Test ######

# Dataset: Titanic; Wanting to know if survival was associated with passenger class.

data("Titanic")


# (a) Collapsing the Titanic table into a 2D contingency table of Class vs Survived.

class_survived <- apply(Titanic, c("Class", "Survived"), sum)


# (b) Run a chi-square test on it. Is there a significant relationship? How do you know?

chisq.test(class_survived) # Yes there is a significant relationship, the p-value is p-value < 2.2e-16

# which is less than 0.05




##### EX8 Dataset: mtcars — suspecting horsepower and fuel efficiency are related #####

# (a) Calculating the Pearson and Spearman correlation between hp and mpg. When would you prefer Spearman over Pearson?

cor(df$hp, df$mpg, method = "pearson")
cor(df$hp, df$mpg, method = "spearman")

# Spearman would be preferred over Pearson when the data is not normally distributed or has outliers.


# (b) Fitting a linear model predicting mpg from hp. Save it as model and print its summary.

model <- lm(mpg ~ hp, data = df)
summary(model)


# (c) Interpret the coefficient for hp in plain language — what does it mean in real terms?

# The coefficient means for every 1-unit increase in hp, mpg decreases by that 0.06823 on average, holding other factors constant.






#################### Part 5: Visualizations — ggplot2 #########################

##### EX9 Density and Boxplot #####

# (a) Plot the distribution of mpg in mtcars as a density curve. 
# Fill it in "steelblue" with 50% transparency.

ggplot(df, aes(x = mpg)) + geom_density(fill = "steelblue", alpha = 0.5)


# (b) Using iris, create a box plot of Sepal.Length by Species with a different fill color per species.

ggplot(ir, aes(x = Species, y = Sepal.Length, fill = Species)) +
  geom_boxplot() +
  labs(
    title = "Sepal Length by Species",
    x = "Species",
    y = "Sepal Length"
  ) +
  theme_minimal()




##### EX10 #####

# (a) Creating a scatterplot of wt (x) vs mpg (y), with points colored by cyl as a category.

ggplot(df, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "Wt vs Mpg",
    x = "Weight",
    y = "Miles per gallon",
    color = "Cylinders"
  ) +
  theme_minimal()



# (b) Adding a single overall linear regression line across all data (not one line per cylinder group).

ggplot(df, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "black") +
  labs(
    title = "wt Vs mpg",
    x = "Weight",
    y = "Miles per gallon",
    color = "Cylinders"
  ) +
  theme_minimal()


# (c) Adding a descriptive title, clear axis labels, and apply theme_minimal().

ggplot(df, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "black") +
  labs(
    title = "THE RELATIONSHIP BETWEEN WEIGHT AND FUEL EFFICIENCY OF A VEHICLE",
    x = "WEIGHT OF VEHICLE (1000 LBS) ",
    y = "FUEL EFFICIENCY (MPG) ",
    color = "Cylinders"
  ) +
  theme_minimal()



