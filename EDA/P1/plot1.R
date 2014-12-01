# set project working directory
project = "C:\\GIT\\DS\\exp_analysis\\project1"
if (!file.exists(project)) { dir.create(project) }
setwd(project)

# download power consumption data files
if (!file.exists(".\\household_power_consumption.txt")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "power.zip")
    unzip("power.zip")
}

# read in obs on Feb 1 and 2, 2007
H <- read.table(".\\household_power_consumption.txt", sep = ";", nrows = 1, stringsAsFactors = FALSE)
P <- read.table(".\\household_power_consumption.txt", sep = ";", nrows = 2880, skip = 66637)
names(P) <- as.character(as.vector(H[1, ]))

# base plot
with(P, hist(Global_active_power, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", col = "red"))

# save to PNG
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()