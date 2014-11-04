# Week 2 Quiz
prepare <- function() {
    # set up a quiz folder
    quiz <- "C:\\GIT\\datasciencecoursera\\getcleandata\\quiz2"
    if (!file.exists(quiz)) { dir.create(quiz) }
    setwd(quiz)
    
    # load packages
    library(httr)
    library(httpuv)
    library(jsonlite)
    library(data.table)
    library(sqldf)
}

prepare()

######################### Question 1

# Register an application with the Github API here https://github.com/settings/applications. 
# Access the API to get information on your instructors repositories 
# (hint: this is the url you want "https://api.github.com/users/jtleek/repos"). 
# Use this data to find the time that the datasharing repo was created. What time was it created? 
# This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
# You may also need to run the code in the base R package and not R studio. 

######################### Answer 1

# Find OAuth settings for github - http://developer.github.com/v3/oauth
endpoints = oauth_endpoints("github")

# Register an application at github first. Insert your client ID and Secret
myapp = oauth_app("Quiz2", "44c59e6ca01b35458739", "e63bbe3ef37dd1e6dd8c5467a9050bb8d3f6ca26")

# Get OAuth credentials
github_token = oauth2.0_token(endpoints, myapp)

# Use API
handle <- config(token = github_token)
req = GET("https://api.github.com/users/jtleek/repos", handle) 
stop_for_status(req) 
json = content(req) 

# Find the answer
json = fromJSON(toJSON(json))
print(json[json$name == "datasharing", "created_at"])

######################### Question 2

# The sqldf package allows for execution of SQL commands on R data frames. We will use the sqldf 
# package to practice the queries we might send with the dbSendQuery command in RMySQL. 
# Download the American Community Survey data and load it into an R object called acs
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv 
# Which of the following commands will select only the data for the probability weights pwgtp1 
# with ages less than 50?

######################### Answer 2

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
survey = "survey.csv"
if (!file.exists(survey)) { download.file(url, survey) }

acs <- as.data.table(read.csv(survey))
p <- sqldf("select pwgtp1 from acs where AGEP < 50")

######################### Question 3

# Using the same data frame you created in the previous problem, what is the equivalent 
# function to unique(acs$AGEP)

######################### Answer 3

a <- sqldf("select distinct AGEP from acs")

######################### Question 4

# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
# http://biostat.jhsph.edu/~jleek/contact.html 
# (Hint: the nchar() function in R may be helpful)

######################### Answer 4

con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
for (i in c(10, 20, 30, 100)) {
    print(paste(i, "th line has ", nchar(htmlCode[i]), " chars", sep = ""))
}

######################### Question 5

# Read this data set into R and report the sum of the numbers in the fourth of the nine columns. 
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for 
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for 
# (Hint this is a fixed width file format)

######################### Answer 5

f <- url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
s = read.fwf(f, c(10, 13, 9), skip = 4)
sum(s$V3)