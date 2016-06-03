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

# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
library(dplyr)
NEI <- tbl_df(NEI)
baltimore <- filter(NEI, fips == "24510")
SCC <- tbl_df(SCC)

vehicle_source1 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, Short.Name))
vehicle_source2 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, EI.Sector))
vehicle_source3 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, SCC.Level.One))
vehicle_source4 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, SCC.Level.Two))
vehicle_source5 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, SCC.Level.Three))
vehicle_source6 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, SCC.Level.Four))

bind <- rbind(vehicle_source1, vehicle_source2, vehicle_source3, vehicle_source4, vehicle_source5, vehicle_source6)
vehicle_sources <- bind[unique(bind$SCC),]
vehicle_emission <- filter(baltimore, SCC %in% vehicle_sources$SCC)

by_year <- group_by(vehicle_emission, year)
library(ggplot2)
total <- summarize(by_year, Emissions = sum(Emissions))
qplot(year, Emissions, data = total, geom = c("boxplot"), main = "Total Emissions from Motor Vehicle in Baltimore")
dev.copy(png, "plot5.png")
dev.off()
