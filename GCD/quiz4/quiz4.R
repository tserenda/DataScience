# Week 4 Quiz
prepare <- function() {
    # set up a quiz folder
    quiz <- "C:\\GIT\\DS\\clean_data\\quiz4"
    if (!file.exists(quiz)) { dir.create(quiz) }
    setwd(quiz)
    
    # load packages
    library(dplyr)
    if (!require(quantmod)) {
        install.packages("quantmod")
        library(quantmod)
    }
    
    if (!require(lubridate)) {
        install.packages("lubridate")
        library(lubridate)
    }
}

prepare()

######################### Question 1

# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
# and load the data into R. The code book, describing the variable names is here: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf  
# Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
# What is the value of the 123 element of the resulting list?

######################### Answer 1

surveyUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
idaho = "idaho.csv"
if (!file.exists(idaho)) { download.file(surveyUrl, idaho) }
HD = read.csv(idaho)

codebookUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
codebook = "codebook.pdf"
if (!file.exists(codebook)) { download.file(codebookUrl, codebook) }

print(strsplit(names(HD), "wgtp")[[123]])

######################### Question 2

# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 
# Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table 

######################### Answer 2

# load GDP data
gdpUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
gdpFile = "GDP.csv"
if (!file.exists(gdpFile)) { download.file(gdpUrl, gdpFile) }
GDP = read.csv(gdpFile, skip = 4, colClasses = "character")

# clean GDP Data
GDP <- select(GDP, -c(X.2, X.5, X.6, X.7, X.8, X.9))
names(GDP) <- c("Code", "Rank", "Country", "Output")
GDP <- GDP[GDP$Code != "", ] # drop rows with empty values
GDP$Rank <- as.integer(GDP$Rank) # change Rank class to integer
GDP$Output <- gsub(pattern = ",", replacement = "", GDP$Output) # remove comma
GDP$Output <- suppressWarnings(as.numeric(GDP$Output)) # change Output class to numeric
GDP <- GDP[!is.na(GDP$Rank), ]
print(mean(GDP$Output, na.rm = TRUE))

######################### Question 3

# In the data set from Question 2 what is a regular expression that would allow you 
# to count the number of countries whose name begins with "United"? 
# Assume that the variable with the country names in it is named countryNames. 
# How many countries begin with United? 

######################### Answer 3

print(length(grep(pattern = "^United", GDP$Country)))

######################### Question 4

# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
# Match the data based on the country shortcode. Of the countries for which the end of 
# the fiscal year is available, how many end in June? 
# Original data sources: 
# http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats 

######################### Answer 4

# load GDP data
gdpUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
gdpFile = "GDP.csv"
if (!file.exists(gdpFile)) { download.file(gdpUrl, gdpFile) }
GDP = read.csv(gdpFile, skip = 4, colClasses = "character")

# clean GDP Data
GDP <- select(GDP, -c(X.2, X.5, X.6, X.7, X.8, X.9))
names(GDP) <- c("Code", "Rank", "Country", "Output")
GDP <- GDP[GDP$Code != "", ] # drop rows with empty values
GDP$Rank <- as.integer(GDP$Rank) # change Rank class to integer
GDP$Output <- gsub(pattern = ",", replacement = "", GDP$Output) # remove comma
GDP$Output <- suppressWarnings(as.numeric(GDP$Output)) # change Output class to numeric
GDP <- GDP[!is.na(GDP$Rank), ]

# Load country data
countryUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
countryInfo = "country.csv"
if (!file.exists(countryInfo)) { download.file(countryUrl, countryInfo) }
CTY = read.csv(countryInfo, colClasses = "character")

GDP <- GDP[match(CTY$CountryCode, GDP$Code), ]
GDP <- GDP[!is.na(GDP$Rank),]

pattern = "Fiscal year end: +June +"
print(length(grep(pattern, CTY$Special.Notes, ignore.case = T, value = T)))

######################### Question 5

# You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices 
# for publicly traded companies on the NASDAQ and NYSE. Use the following code to download 
# data on Amazon's stock price and get the times the data was sampled.
# library(quantmod)
# amzn = getSymbols("AMZN",auto.assign=FALSE)
# sampleTimes = index(amzn) 
# How many values were collected in 2012? How many values were collected on Mondays in 2012?

######################### Answer 5

if (!require(quantmod)) {
    install.packages("quantmod")
    library(quantmod)
}

if (!require(lubridate)) {
    install.packages("lubridate")
    library(lubridate)
}

amzn = getSymbols("AMZN", auto.assign = FALSE)
sampleTimes = index(amzn)
print(length(dates <- grep(pattern = "^2012", sampleTimes, value = T)))
print(length(grep("Monday", weekdays(ymd(dates)))))


