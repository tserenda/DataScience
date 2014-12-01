setwd("C:\\GIT\\DS\\EDA\\P2")
nei <- "summarySCC_PM25.rds"
scc <- "Source_Classification_Code.rds"
if (!file.exists(nei) | !file.exists(scc)) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
        unzip("data.zip")
}
NEI <- transform(readRDS(nei), fips = factor(fips), SCC = factor(SCC),
                 Pollutant = factor(Pollutant), type = factor(type), year = factor(year))

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?
# Which have seen increases in emissions from 1999-2008?
# Use the ggplot2 plotting system to make a plot answer this question.
library(dplyr)
NEI <- tbl_df(NEI)
baltimore <- filter(NEI, fips == "24510")
by_year_type <- group_by(baltimore, year, type)
library(ggplot2)
total <- summarize(by_year_type, Emissions = sum(Emissions))
qplot(year, Emissions, data = total, facets = .~ type, geom = c("boxplot"), main = "Total Emissions from PM2.5 in Baltimore", 
      ylab = expression('Total PM'[2.5]*" Emission"))
dev.copy(png, "plot3.png")
dev.off()
