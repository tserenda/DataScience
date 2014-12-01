f <- "C:/GIT/datasciencecoursera/rprogramming/quiz1/hw1_data.csv"
d <- read.csv(f)

# Q11: In the dataset provided for this Quiz, what are the column names of the dataset?
names(d)

# Q12: Extract the first 2 rows of the data frame and print them to the console.
# What does the output look like?
d[1:2, ]

# Q13: How many observations (i.e. rows) are in this data frame?
nrow(d)

# Q14: Extract the last 2 rows of the data frame and print them to the console.
# What does the output look like?
tail(d, n = 2)

# Q15: What is the value of Ozone in the 47th row?
d[47, "Ozone"]

# Q16: How many missing values are in the Ozone column of this data frame?
sum(is.na(d["Ozone"]))

# Q17: What is the mean of the Ozone column in this dataset?
# Exclude missing values (coded as NA) from this calculation.
mean(d[, "Ozone"], na.rm = T)

# Q18: Extract the subset of rows of the data frame where Ozone values are above 31 and
# Temp values are above 90. What is the mean of Solar.R in this subset?
s <- d["Ozone"] > 31 & d["Temp"] > 90
mean(d[s, "Solar.R"], na.rm = T)

# Q19: What is the mean of "Temp" when "Month" is equal to 6?
s <- d["Month"] == 6
mean(d[s, "Temp"], na.rm = T)

# Q20: What was the maximum ozone value in the month of May (i.e. Month = 5)?
s <- d["Month"] == 5
max(d[s, "Ozone"], na.rm = T)
