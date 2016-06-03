library(ggplot2)
library(plyr)
library(dplyr)
setwd("C:\\GIT\\DS\\RR\\A2")

# download and load data
storm = "storm.bz2"
if (!file.exists(storm)) { download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", storm) }
dat <- read.csv(bzfile(storm))

# subset relevant variables
sub <- select(tbl_df(dat), c(EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP))

# revalue exponents of PROPDMGEXP and CROPDMGEXP
values = c("-" = "0", "+" = "0", "?" = "0", "h" = "2", "H" = "2", "k" = "3", "K" = "3", "m" = "6", "M" = "6", "b" = "9", "B" = "9")
sub$PROPDMGEXP <- revalue(sub$PROPDMGEXP, values)
levels(sub$PROPDMGEXP)[1] <- "0"
sub$CROPDMGEXP <- revalue(sub$CROPDMGEXP, values)
levels(sub$CROPDMGEXP)[1] <- "0"

# damage = property damage + crop damage
sub <- mutate(sub, DMG = PROPDMG * (10 ^ (as.numeric(PROPDMGEXP) - 1)) + CROPDMG * (10 ^ (as.numeric(CROPDMGEXP) - 1)))

# group by event
by_event <- group_by(sub, EVTYPE)

### ECONOMIC DAMAGE
# total damage per event type
event_damage <- dplyr::summarize(by_event, historic_damage = sum(DMG))

# plot the most damaging 10 events
top10a <- arrange(event_damage, desc(historic_damage))[1:10, ]
with(top10a, qplot(EVTYPE, historic_damage, main = "Most Damaging 10 Events",
                  ylab = "Total Damage in USD", xlab = "", geom = "bar", stat = "identity") + coord_flip())

### SOCIAL DAMAGE
# fatalities per event type
fatalities <- dplyr::summarize(by_event, fatal = sum(FATALITIES))

# plot the most fatal 10 events
top10b <- arrange(fatalities, desc(fatal))[1:10, ]
with(top10b, qplot(EVTYPE, log(fatal), main = "Most Fatal 10 Events",
                  ylab = "Fatalities", xlab = "", geom = "bar", stat = "identity") + coord_flip())

# injuries per event type
injuries <- dplyr::summarize(by_event, injury = sum(INJURIES))

# plot 10 events with the most injuries
top10c <- arrange(injuries, desc(injury))[1:10, ]
with(top10c, qplot(EVTYPE, log(injury), main = "10 Events with Most Injuries",
                   ylab = "Inuries", xlab = "", geom = "bar", stat = "identity") + coord_flip())
