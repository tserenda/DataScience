############################# Course Project ############################# 

prepare <- function() {
    # create a folder for the project and set the working directory
    project <- "C:\\GIT\\datasciencecoursera\\getcleandata\\project"
    if (!file.exists(project)) { dir.create(project) }
    setwd(project)
    
    # load required packages
    library(httr)
    library(httpuv)
    library(data.table)
    library(dplyr)
}

prepare()

# dataset files
samsung.dir = ".\\samsung"

features_info.txt = paste(samsung.dir, "features_info.txt", sep = "\\")
features.txt = paste(samsung.dir, "features.txt", sep = "\\")
activity_labels.txt = paste(samsung.dir, "activity_labels.txt", sep = "\\")

# test data set files
test.dir = paste(samsung.dir, "test", sep = "\\")
X_test.txt = paste(test.dir, "X_test.txt", sep = "\\")
y_test.txt = paste(test.dir, "y_test.txt", sep = "\\")
subject_test.txt = paste(test.dir, "subject_test.txt", sep = "\\")

# train data set files
train.dir = paste(samsung.dir, "train", sep = "\\")
X_train.txt = paste(train.dir, "X_train.txt", sep = "\\")
y_train.txt = paste(train.dir, "y_train.txt", sep = "\\")
subject_train.txt = paste(train.dir, "subject_train.txt", sep = "\\")

### Prepare test data set
# Add 561 variable names found in features.txt to X_test.txt
X_test.txt.tbl = read.table(X_test.txt)
features.txt.tbl = read.table(features.txt)
names(X_test.txt.tbl) = features.txt.tbl$V2

# Substitute 6 acitivities from activity_labels.txt for labels in y_test.txt
activity_labels.txt.tbl = read.table(activity_labels.txt)
y_test.txt.tbl = read.table(y_test.txt)
names(y_test.txt.tbl) = "Activity"
for (i in 1:nrow(y_test.txt.tbl)) {
    j <- y_test.txt.tbl[i, "Activity"]
    y_test.txt.tbl[i, "Activity"] = as.character(activity_labels.txt.tbl[j, "V2"])
}

# Bind 2947 columns in subject_test.txt, X_test.txt, y_test.txt
subject_test.txt.tbl = read.table(subject_test.txt)
names(subject_test.txt.tbl) = "Subject"
test <- cbind(subject_test.txt.tbl, y_test.txt.tbl, X_test.txt.tbl)

### Prepare train data set
# Add 561 variable names found in features.txt to X_train.txt
X_train.txt.tbl = read.table(X_train.txt)
features.txt.tbl = read.table(features.txt)
names(X_train.txt.tbl) = features.txt.tbl$V2
    
# Substitute 6 acitivities from activity_labels.txt for labels in y_train.txt
activity_labels.txt.tbl = read.table(activity_labels.txt)
y_train.txt.tbl = read.table(y_train.txt)
names(y_train.txt.tbl) = "Activity"
for (i in 1:nrow(y_train.txt.tbl)) {
    j <- y_train.txt.tbl[i, "Activity"]
    y_train.txt.tbl[i, "Activity"] = as.character(activity_labels.txt.tbl[j, "V2"])
}
    
# Bind 2947 columns in subject_train.txt, X_train.txt, y_train.txt
subject_train.txt.tbl = read.table(subject_train.txt)
names(subject_train.txt.tbl) = "Subject"
train <- cbind(subject_train.txt.tbl, y_train.txt.tbl, X_train.txt.tbl)

# Row bind test and train data frames
TestTrain <- rbind(test, train)

# Extracts only the measurements on the mean and standard deviation for each measurement
TestTrain <- TestTrain[, c(1, 2, grep("mean\\(\\)|std\\(\\)", colnames(TestTrain)))]

# Create a second, independent tidy data set with the average of 
# each variable for each activity and each subject

g <- group_by(TestTrain, Subject, Activity)
tidy <- summarize(g, 
                CMtBodyAccmeanX = mean(g$"tBodyAcc-mean()-X"),              
                CMtBodyAccmeanY = mean(g$"tBodyAcc-mean()-Y"),             
                CMtBodyAccmeanZ = mean(g$"tBodyAcc-mean()-Z"),                    
                CMtBodyAccstdX = mean(g$"tBodyAcc-std()-X"),             
                CMtBodyAccstdY = mean(g$"tBodyAcc-std()-Y"),            
                CMtBodyAccstdZ = mean(g$"tBodyAcc-std()-Z"),            
                CMtGravityAccmeanX = mean(g$"tGravityAcc-mean()-X"),        
                CMtGravityAccmeanY = mean(g$"tGravityAcc-mean()-Y"),       
                CMtGravityAccmeanZ = mean(g$"tGravityAcc-mean()-Z"),        
                CMtGravityAccstdX = mean(g$"tGravityAcc-std()-X"),         
                CMtGravityAccstdY = mean(g$"tGravityAcc-std()-Y"),         
                CMtGravityAccstdZ = mean(g$"tGravityAcc-std()-Z"),         
                CMtBodyAccJerkmeanX = mean(g$"tBodyAccJerk-mean()-X"),            
                CMtBodyAccJerkmeanY = mean(g$"tBodyAccJerk-mean()-Y"),      
                CMtBodyAccJerkmeanZ = mean(g$"tBodyAccJerk-mean()-Z"),      
                CMtBodyAccJerkstdX = mean(g$"tBodyAccJerk-std()-X"),        
                CMtBodyAccJerkstdY = mean(g$"tBodyAccJerk-std()-Y"),        
                CMtBodyAccJerkstdZ = mean(g$"tBodyAccJerk-std()-Z"),       
                CMtBodyGyromeanX = mean(g$"tBodyGyro-mean()-X"),          
                CMtBodyGyromeanY = mean(g$"tBodyGyro-mean()-Y"),          
                CMtBodyGyromeanZ = mean(g$"tBodyGyro-mean()-Z"),          
                CMtBodyGyrostdX = mean(g$"tBodyGyro-std()-X"),           
                CMtBodyGyrostdY = mean(g$"tBodyGyro-std()-Y"),           
                CMtBodyGyrostdZ = mean(g$"tBodyGyro-std()-Z"),           
                CMtBodyGyroJerkmeanX = mean(g$"tBodyGyroJerk-mean()-X"),      
                CMtBodyGyroJerkmeanY = mean(g$"tBodyGyroJerk-mean()-Y"),      
                CMtBodyGyroJerkmeanZ = mean(g$"tBodyGyroJerk-mean()-Z"),      
                CMtBodyGyroJerkstdX = mean(g$"tBodyGyroJerk-std()-X"),      
                CMtBodyGyroJerkstdY = mean(g$"tBodyGyroJerk-std()-Y"),       
                CMtBodyGyroJerkstdZ = mean(g$"tBodyGyroJerk-std()-Z"),       
                CMtBodyAccMagmean = mean(g$"tBodyAccMag-mean()"),              
                CMtBodyAccMagstd = mean(g$"tBodyAccMag-std()"),           
                CMtGravityAccMagmean = mean(g$"tGravityAccMag-mean()"),      
                CMtGravityAccMagstd = mean(g$"tGravityAccMag-std()"),        
                CMtBodyAccJerkMagmean = mean(g$"tBodyAccJerkMag-mean()"),      
                CMtBodyAccJerkMagstd = mean(g$"tBodyAccJerkMag-std()"),       
                CMtBodyGyroMagmean = mean(g$"tBodyGyroMag-mean()"),         
                CMtBodyGyroMagstd = mean(g$"tBodyGyroMag-std()"),         
                CMtBodyGyroJerkMagmean = mean(g$"tBodyGyroJerkMag-mean()"),     
                CMtBodyGyroJerkMagstd = mean(g$"tBodyGyroJerkMag-std()"),      
                CMfBodyAccmeanX = mean(g$"fBodyAcc-mean()-X"),           
                CMfBodyAccmeanY = mean(g$"fBodyAcc-mean()-Y"),           
                CMfBodyAccmeanZ = mean(g$"fBodyAcc-mean()-Z"),          
                CMfBodyAccstdX = mean(g$"fBodyAcc-std()-X"),            
                CMfBodyAccstdY = mean(g$"fBodyAcc-std()-Y"),            
                CMfBodyAccstdZ = mean(g$"fBodyAcc-std()-Z"),            
                CMfBodyAccJerkmeanX = mean(g$"fBodyAccJerk-mean()-X"),       
                CMfBodyAccJerkmeanY = mean(g$"fBodyAccJerk-mean()-Y"),      
                CMfBodyAccJerkmeanZ = mean(g$"fBodyAccJerk-mean()-Z"),       
                CMfBodyAccJerkstdX = mean(g$"fBodyAccJerk-std()-X"),        
                CMfBodyAccJerkstdY = mean(g$"fBodyAccJerk-std()-Y"),        
                CMfBodyAccJerkstdZ = mean(g$"fBodyAccJerk-std()-Z"),        
                CMfBodyGyromeanX = mean(g$"fBodyGyro-mean()-X"),         
                CMfBodyGyromeanY = mean(g$"fBodyGyro-mean()-Y"),          
                CMfBodyGyromeanZ = mean(g$"fBodyGyro-mean()-Z"),          
                CMfBodyGyrostdX = mean(g$"fBodyGyro-std()-X"),           
                CMfBodyGyrostdY = mean(g$"fBodyGyro-std()-Y"),           
                CMfBodyGyrostdZ = mean(g$"fBodyGyro-std()-Z"),          
                CMfBodyAccMagmean = mean(g$"fBodyAccMag-mean()"),          
                CMfBodyAccMagstd = mean(g$"fBodyAccMag-std()"),           
                CMfBodyBodyAccJerkMagmean = mean(g$"fBodyBodyAccJerkMag-mean()"),  
                CMfBodyBodyAccJerkMagstd = mean(g$"fBodyBodyAccJerkMag-std()"),   
                CMfBodyBodyGyroMagmean = mean(g$"fBodyBodyGyroMag-mean()"),    
                CMfBodyBodyGyroMagstd = mean(g$"fBodyBodyGyroMag-std()"),      
                CMfBodyBodyGyroJerkMagmean = mean(g$"fBodyBodyGyroJerkMag-mean()"), 
                CMfBodyBodyGyroJerkMagstd = mean(g$"fBodyBodyGyroJerkMag-std()")
            )
tidy <- as.data.frame(tidy)
write.table(tidy, "tidy.txt", row.name = FALSE)