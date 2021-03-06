setwd("C:\\GIT\\DS\\EDA\\P2")
nei <- "summarySCC_PM25.rds"
scc <- "Source_Classification_Code.rds"
if (!file.exists(nei) | !file.exists(scc)) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
        unzip("data.zip")
}
NEI <- transform(readRDS(nei), fips = factor(fips), SCC = factor(SCC),
                 Pollutant = factor(Pollutant), type = factor(type), year = factor(year))

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for
# each of the years 1999, 2002, 2005, and 2008.
library(dplyr)
NEI <- tbl_df(NEI)
by_year <- group_by(NEI, year)
total.emission <- summarize(by_year, y = sum(Emissions))
total.emission$y <- round(total.emission$y/1000)
with(total.emission,
     barplot(y, names.arg = year, main = "Total Emission in the United States 1999-2008",
             ylab = expression('Total PM'[2.5]*" Emission (in thousands)")))
dev.copy(png, "plot1.png")
dev.off()