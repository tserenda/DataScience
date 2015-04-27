setwd("C:\\GIT\\DS\\EDA\\P2")
nei <- "summarySCC_PM25.rds"
scc <- "Source_Classification_Code.rds"
if (!file.exists(nei) | !file.exists(scc)) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
        unzip("data.zip")
}
NEI <- transform(readRDS(nei), fips = factor(fips), SCC = factor(SCC),
                 Pollutant = factor(Pollutant), type = factor(type), year = factor(year))

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.
library(dplyr)
NEI <- tbl_df(NEI)
baltimore <- filter(NEI, fips == "24510")
by_year <- group_by(baltimore, year)
with(summarize(by_year, y = sum(Emissions)),
     barplot(y, names.arg = year, main = "Total Emissions from PM2.5 in Baltimore 1999-2008",
             ylab = expression('Total PM'[2.5]*" Emission")))
dev.copy(png, "plot2.png")
dev.off()