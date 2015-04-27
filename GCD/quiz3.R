# Week 3 Quiz
prepare <- function() {
    # set up a quiz folder
    quiz <- "C:\\GIT\\datasciencecoursera\\getcleandata\\quiz3"
    if (!file.exists(quiz)) { dir.create(quiz) }
    setwd(quiz)
    
    # load packages
    library(jpeg)
    library(dplyr)
    library(stringr)
}

prepare()

######################### Question 1

# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
# and load the data into R. The code book, describing the variable names is here: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf  
# Create a logical vector that identifies the households on greater than 10 acres who sold more 
# than $10,000 worth of agriculture products. Assign that logical vector to the variable agricultureLogical. 
# Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE. 
# which(agricultureLogical) What are the first 3 values that result?

######################### Answer 1

surveyUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
idaho = "idaho.csv"
if (!file.exists(idaho)) { download.file(surveyUrl, idaho) }
HD = read.csv(idaho)

codebookUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
codebook = "codebook.pdf"
if (!file.exists(codebook)) { download.file(codebookUrl, codebook) }

agricultureLogical <- (HD$ACR == 3 & HD$AGS ==  6)
print(head(which(agricultureLogical), 3))

######################### Question 2

# Using the jpeg package read in the following picture of your instructor into R 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg  
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)

######################### Answer 2

jeffUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
jeffJpg = "jeff.jpg"
if (!file.exists(jeffJpg)) { download.file(jeffUrl, jeffJpg, mode = "wb") }
jeff = readJPEG(jeffJpg, native = TRUE)
print(quantile(jeff, c(0.3, 0.8)))

######################### Question 3

# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
# Match the data based on the country shortcode. How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame? 
# Original data sources: 
# http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats 

######################### Answer 3

# load GDP data
gdpUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
gdpFile = "GDP.csv"
if (!file.exists(gdpFile)) { download.file(gdpUrl, gdpFile) }
GDP = read.csv(gdpFile, skip = 4, colClasses = "character")

# # examine GDP Data
# dim(GDP)
# names(GDP)
# str(GDP)
# GDP$X # variable for country codes, remove empty characters, non-country codes present
# unique(GDP$X.1) # variable for GDP ranking, has few incompatible values to be cleaned, converto to integer
# unique(GDP$X.2) # drop empty variable
# unique(GDP$X.3) # variable for country names, has a dozen non-country values
# GDP$X.4 # variable for GDP numbers, has many missing values
# unique(GDP$X.5) # drop empty variable
# unique(GDP$X.6)  # drop empty variable
# unique(GDP$X.7)  # drop empty variable
# unique(GDP$X.8)  # drop empty variable
# unique(GDP$X.9)  # drop empty variable

# clean GDP Data
GDP <- select(GDP, -c(X.2, X.5, X.6, X.7, X.8, X.9))
names(GDP) <- c("Code", "Rank", "Country", "Output")
GDP <- GDP[GDP$Code != "", ] # drop rows with empty values
GDP$Rank <- as.integer(GDP$Rank) # change Rank class to integer
GDP$Output <- str_replace_all(GDP$Output, pattern = ",", replacement = "") # remove separator
GDP$Output <- suppressWarnings(as.numeric(GDP$Output)) # change Output class to numeric

# Load country data
countryUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
countryInfo = "country.csv"
if (!file.exists(countryInfo)) { download.file(countryUrl, countryInfo) }
CTY = read.csv(countryInfo, colClasses = "character")

# # examine country data
# dim(CTY)
# names(CTY)
# head(CTY, 1)
# tail(CTY, 1)
# str(CTY)
# length(CTY$CountryCode)

GDP <- GDP[match(CTY$CountryCode, GDP$Code), ]
GDP <- GDP[!is.na(GDP$Rank),]
GDP <- arrange(GDP, desc(Rank))
print(GDP[13, "Country"])

######################### Question 4

# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group? 

######################### Answer 4

OECD <- CTY[CTY$Income.Group == "High income: OECD",]
average_OECD <- mean(GDP[match(OECD$CountryCode, GDP$Code), "Rank"], na.rm = TRUE)
print(average_OECD)

nonOECD <- CTY[CTY$Income.Group == "High income: nonOECD",]
average_nonOECD <- mean(GDP[match(nonOECD$CountryCode, GDP$Code), "Rank"], na.rm = TRUE)
print(average_nonOECD)

######################### Question 5

# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?

######################### Answer 5

GDP2 <- merge(GDP, CTY, by.x = "Code", by.y = "CountryCode")
print(nrow(GDP2[GDP2$Rank < 39 & GDP2$Income.Group == "Lower middle income", ]))


