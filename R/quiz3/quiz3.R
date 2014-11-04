# Week 3 Quiz

# For Q1 & 2
library(datasets)
data(iris)

# Q1: What is the mean of 'Sepal.Length' for the species virginica. Please only enter the numeric result and nothing else.
s <- split(iris, iris$Species)
sapply(s, function(x) colMeans(x[, c("Sepal.Length", "Sepal.Width")]))

# Q2: What R code returns a vector of the means of the variables 'Sepal.Length', 'Sepal.Width', 'Petal.Length', and 'Petal.Width'?
colMeans(iris[1:4]) # or
apply(iris[, 1:4], 2, mean) 

# For Q3 & 4
library(datasets)
data(mtcars)

# Q3: How can one calculate the average miles per gallon (mpg) by number of cylinders in the car (cyl)?
tapply(mtcars$mpg, mtcars$cyl, mean) # or
with(mtcars, tapply(mpg, cyl, mean))

# Q4: What is the absolute difference between the average horsepower of 4-cylinder cars and the average horsepower of 8-cylinder cars?
h <- tapply(mtcars$hp, mtcars$cyl, mean)
abs(h[1] - h[3])

# Q5: If you run debug(ls), what happens when you next call the 'ls' function?
# A5: Execution of 'ls' will suspend at the beginning of the function and you will be in the browser.