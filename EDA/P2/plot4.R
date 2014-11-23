setwd("C:\\GIT\\DS\\EDA\\P2")
nei <- "summarySCC_PM25.rds"
scc <- "Source_Classification_Code.rds"
if (!file.exists(nei) | !file.exists(scc)) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
        unzip("data.zip")
}
NEI <- transform(readRDS(nei), fips = factor(fips), SCC = factor(SCC),
                 Pollutant = factor(Pollutant), type = factor(type), year = factor(year))
SCC <- readRDS(scc)

# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
library(dplyr)
NEI <- tbl_df(NEI)
SCC <- tbl_df(SCC)

coal_source1 <- filter(SCC, grepl("coal", ignore.case = TRUE, Short.Name))
coal_source2 <- filter(SCC, grepl("coal", ignore.case = TRUE, EI.Sector))
coal_source3 <- filter(SCC, grepl("coal", ignore.case = TRUE, SCC.Level.One))
coal_source4 <- filter(SCC, grepl("coal", ignore.case = TRUE, SCC.Level.Two))
coal_source5 <- filter(SCC, grepl("coal", ignore.case = TRUE, SCC.Level.Three))
coal_source6 <- filter(SCC, grepl("coal", ignore.case = TRUE, SCC.Level.Four))

bind <- rbind(coal_source1, coal_source2, coal_source3, coal_source4, coal_source5, coal_source6)
coal_sources <- bind[unique(bind$SCC),]
coal_emission <- filter(NEI, SCC %in% coal_sources$SCC)

by_year <- group_by(coal_emission, year)
library(ggplot2)
total <- summarize(by_year, Emissions = sum(Emissions))
qplot(year, Emissions, data = total, geom = c("boxplot"), main = "Total Emissions from Coal Related Sources")
dev.copy(png, "plot4.png")
dev.off()
