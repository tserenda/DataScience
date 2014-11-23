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

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor
# vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater
# changes over time in motor vehicle emissions?

library(dplyr)
NEI <- tbl_df(NEI)
sub <- filter(NEI, fips %in% c("24510", "06037"))
library(plyr)
sub$fips <- revalue(sub$fips, c("24510" = "Baltimore", "06037" = "Los Angeles"))

SCC <- tbl_df(SCC)

vehicle_src1 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, Short.Name))
vehicle_src2 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, EI.Sector))
vehicle_src3 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, SCC.Level.One))
vehicle_src4 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, SCC.Level.Two))
vehicle_src5 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, SCC.Level.Three))
vehicle_src6 <- filter(SCC, grepl("vehicle", ignore.case = TRUE, SCC.Level.Four))

combo <- rbind(vehicle_src1, vehicle_src2, vehicle_src3, vehicle_src4, vehicle_src5, vehicle_src6)
vehicle_sources <- combo[unique(combo$SCC), ]

vehicle_emission <- filter(sub, SCC %in% vehicle_sources$SCC)
by_year_fips <- group_by(vehicle_emission, year, fips)
total <- dplyr::summarize(by_year_fips, Emissions = sum(Emissions))

library(lattice)
xyplot(Emissions ~ year | fips, data = total, main = "Total Emissions from Motor Vehicle in Baltimore and Los Angeles",
       panel = function(x, y, ...) {
               panel.xyplot(x, y, ...)
               panel.lmline(x, y, col = 2)
       })
dev.copy(png, "plot6.png")
dev.off()
