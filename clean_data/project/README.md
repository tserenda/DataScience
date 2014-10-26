---
title: "README"
author: "Ari"
date: "Sunday, October 26, 2014"
output: html_document
---

This is README document describing the <b>run_analysis.R</b> script that performs analysis on data collected from the accelerometers from the Samsung Galaxy S smartphone. This script does the following. <br><br>
1.Merges the training and the test sets to create one data set.<br>
2.Extracts only the measurements on the mean and standard deviation for each measurement. <br>
3.Uses descriptive activity names to name the activities in the data set<br>
4.Appropriately labels the data set with descriptive variable names. <br>
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.<br><br>

The script can be run simply by sourcing the script in R Studio as long as the Samsung data is in the working directory.<br><br>
```{r}
source("run_analysis.R")
```

<br><br>The output of the script will be written as a text file (tidy.txt) in the working directory.
