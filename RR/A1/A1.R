setwd("C:\\GIT\\DS\\RR\\assignment1")
data = "activity.csv"
if (!file.exists(data)) {
        download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip", "activity.zip")
        unzip("activity.zip")
}

## Load and preprocess the original data
A <- read.csv(data)
A$date <- as.Date(A$date)

# Make a histogram of the total number of steps taken each day
B <- na.omit(A)
by_date <- group_by(B, date)
total <- summarize(by_date, daily_steps = sum(steps))
hist(total$daily_steps, labels = T, main = "Mean Total Number of Steps Taken per Day", xlab = "Steps")

# Mean & median total number of steps taken per day
mean(total$daily_steps)
median(total$daily_steps)

## Average daily activity pattern
# Time series plot of the 5-minute interval and the average number of steps taken, averaged across all days
by_interval <- group_by(B, interval)
activity <- summarize(by_interval, ave_steps = mean(steps))
with(activity, plot(interval, ave_steps, type = "l", ylab = "Steps averaged across all days",
                    main = "Number of Steps per Interval"))

# 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
max_steps <- max(activity$ave_steps)
most_active_interval <- activity[which(activity$ave_steps == max_steps), ]
cat("Interval", most_active_interval$interval, "is the most active with", 
    round(most_active_interval$ave_steps), "steps")

## Imputing missing values
# 1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
incomplete <- !complete.cases(A)
cat("Number of missing values:", sum(incomplete))

# 2. Create a new dataset that is equal to the original dataset but with the missing data filled in with 
# the total mean steps per interval.
intervals_per_day = 24 * 12
B <- A
B[incomplete, ]$steps <- round(mean_per_day / intervals_per_day)

# 3. Make a histogram of the total number of steps taken each day and calculate and report the mean and 
# median total number of steps taken per day. Do these values differ from the estimates from the first 
# part of the assignment? What is the impact of imputing missing data on the estimates of the total daily 
# number of steps?
by_date <- group_by(B, date)
total <- summarize(by_date, daily_steps = sum(steps))
hist(total$daily_steps, labels = TRUE, main = "Mean Total Number of Steps Taken per Day", xlab = "Steps per Day")

mean(total$daily_steps)
median(total$daily_steps)

## Diff in activity patterns between weekdays and weekends
B <- transform(B, day = weekdays(B$date))
B$day <- ifelse(B$day %in% c("Saturday", "Sunday"), "Weekend", "Weekday")

# Time series plot of the 5-minute interval and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 
by_day_interval <- group_by(B, day, interval)
activity <- summarize(by_day_interval, ave_steps = mean(steps))
with(activity, xyplot(ave_steps ~ interval | day, layout = c(1, 2), type = "l", 
                      xlab = "Interval", ylab = "Average Number of Steps"))