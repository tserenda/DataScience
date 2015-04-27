# Week 1 Quiz
prepare <- function() {
    quiz <- "C:\\GIT\\datasciencecoursera\\getcleandata\\quiz1"
    if (!file.exists(quiz)) { dir.create(quiz) }
    setwd(quiz)
    library(xlsx)
    library(data.table)
    library(XML)
}

prepare()

### Q1
#   The American Community Survey distributes downloadable data about United States communities.
#   Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#   and load the data into R. The code book, describing the variable names is here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#   How many properties are worth $1,000,000 or more?
### A1
housingUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
housingFile = "Idaho.csv"
if (!file.exists(housingFile)) { download.file(housingUrl, housingFile) }

codebookUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
codebookPdf = "Codebook.pdf"
if (!file.exists(codebookPdf)) { download.file(codebookUrl, codebookPdf) }

HD <- as.data.table(read.csv(housingFile))
print("A1:")
print(nrow(HD[HD$VAL == 24, ])) # Look at the VAL variable in the codebook

### Q2
#   Use the data you loaded from Question 1. Consider the variable FES in the code book.
#   Which of the "tidy data" principles does this variable violate?
### A2
answer = "Tidy data has one variable per column."
print("A2:")
print(answer)

### Q3
#   Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
#   Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat
#   What is the value of: sum(dat$Zip*dat$Ext,na.rm=T)
### A3
natGasUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
natGasFile = "Nat Gas.xlsx"
if (!file.exists(natGasFile)) { download.file(natGasUrl, natGasFile, mode = "wb") }

colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx(natGasFile, sheetIndex = 1, colIndex = colIndex, rowIndex = rowIndex)
print("A3:")
print(sum(dat$Zip * dat$Ext, na.rm = T))

### Q4
#   Read the XML data on Baltimore restaurants from here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
#   How many restaurants have zipcode 21231? 
### A4
restaurantsUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
restaurantsFile = "Restaurants.xml"
if (!file.exists(restaurantsFile)) { download.file(restaurantsUrl, restaurantsFile) }
doc <- xmlTreeParse(restaurantsFile, useInternal = TRUE)
rootNode <- xmlRoot(doc)
zipcodes <- xpathSApply(rootNode, "//zipcode", xmlValue)
print("A4:")
print(length(zipcodes[zipcodes == "21231"]))

### Q5
#   The American Community Survey distributes downloadable data about United States communities.
#   Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
#   using the fread() command load the data into an R object  DT
#   Which of the following is the fastest way to calculate the average value of the variable pwgtp15 
#   broken down by sex using the data.table package? 
### A5
IdahoUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
IdahoFile = "Idaho.csv"
if (!file.exists(IdahoFile)) { download.file(IdahoUrl, IdahoFile) }
DT <- fread(IdahoFile)

race = 1000

e1 <- replicate(race, system.time({ mean(DT[DT$SEX == 1, ]$pwgtp15); mean(DT[DT$SEX == 2, ]$pwgtp15) })[1])
e2 <- replicate(race, system.time({ DT[ , mean(pwgtp15), by = SEX] })[1])
e3 <- replicate(race, system.time({ sapply(split(DT$pwgtp15, DT$SEX), mean) })[1])
e4 <- replicate(race, system.time({ tapply(DT$pwgtp15, DT$SEX,mean) })[1])

e1_av = cumsum(e1) / seq_along(e1)
e2_av = cumsum(e2) / seq_along(e2)
e3_av = cumsum(e3) / seq_along(e3)
e4_av = cumsum(e4) / seq_along(e4)


topY = max(e2_av, e3_av, e4_av)
lowY = min(e2_av, e3_av, e4_av)
plot(e2_av, type="l", col="#FF000099", ylim=c(lowY,topY), xlab="distance", ylab="average time") # red
lines(e3_av, col="#0000FF99") # blue
lines(e4_av, col="#00000099") # black
print("A5:")
print("See the plot")