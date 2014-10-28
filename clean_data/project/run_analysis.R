# load packages
if (!require(plyr)) {
    install.packages("plyr")
    library(plyr)
}

# set project WD
project = "C:\\GIT\\DS\\clean_data\\project"
if (!file.exists(project)) {
    dir.create(project)
}
setwd(project)

# download Samsung data files
samsung = ".\\samsung"
test.dir = paste(samsung, "test", sep = "\\")
train.dir = paste(samsung, "train", sep = "\\")
if (!file.exists(samsung)) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "samsung.zip")
    unzip("samsung.zip")
    file.rename("UCI HAR Dataset", "samsung")
}

# read data files into R
features <- read.table(paste(samsung, "features.txt", sep = "\\"), stringsAsFactors = FALSE)
activities <- read.table(paste(samsung, "activity_labels.txt", sep = "\\"))

X_test <- read.table(paste(test.dir, "X_test.txt", sep = "\\"))
Y_test <- read.table(paste(test.dir, "y_test.txt", sep = "\\"))
subject_test <- read.table(paste(test.dir, "subject_test.txt", sep = "\\"))

X_train <- read.table(paste(train.dir, "X_train.txt", sep = "\\"))
Y_train <- read.table(paste(train.dir, "y_train.txt", sep = "\\"))
subject_train <- read.table(paste(train.dir, "subject_train.txt", sep = "\\"))

# tidy dataset
test <- cbind(subject_test, Y_test, X_test)         # combine test datasets
train <- cbind(subject_train, Y_train, X_train)     # combine train datasets
tt <- rbind(test, train)                            # combine test & train datasets
names(tt) <- c("Subject", "Activity", features$V2)

# subsitute descriptive names for activities
tt$Activity <- factor(tt$Activity, levels = c(1, 2, 3, 4, 5, 6), labels = activities[, 2])

# extract only the measurements on the mean and standard deviation for each measurement
tt <- tt[, c(1, 2, grep("mean\\(\\)|std\\(\\)", colnames(tt)))]

# apply meaningful column names
names(tt)[-c(1:2)] <- sapply(names(tt)[-c(1:2)], function(x) paste("Mean", x, sep = "-"))

# create a data set with the average of each variable for each activity and each subject
tidy <- ddply(tt, .(Subject, Activity), numcolwise(mean))

# write tidy data out
write.table(as.data.frame(tidy), "tidy.txt", row.names = FALSE)