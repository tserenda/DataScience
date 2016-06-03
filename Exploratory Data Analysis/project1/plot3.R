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
dt <- strptime(paste(P$Date, P$Time), "%d/%m/%Y %H:%M:%S")
with(P, plot(dt, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black"))
with(P, lines(dt, Sub_metering_2, col = "red"))
with(P, lines(dt, Sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# save to PNG
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()