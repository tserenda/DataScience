---
title: "README"
author: "Ari"
date: "Sunday, October 26, 2014"
output: html_document
---

<h3>About the project</h3>
This is a project for Getting and Cleaning Data course offered through http://www.coursera.org. There are three files, namely:<br>
<ul>
<li><b>README.md</b>: This document</li>
<li><b>run_analysis.R</b>: This script is the instruction for getting and cleaning raw data into tidy data.</li>
<li><b>Codebook.mnd</b>: This document provides information about variables, experimental study design etc.</li>
</ul>

<u>Raw data</u>: The source comes from the Samsung Galaxy smartphone experiment. 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

It includes measurements of the embedded accelerometer and gyroscope components while subject performing various activities. For more information, refer to the following:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

<u>Tidy data</u>: run_analysis.R scripts generates tidy.txt in the working directory. This file contains tidy data set with the average of each variable for each activity and each subject.

The script can be run simply by sourcing the script in R Studio.<br>
```
source("run_analysis.R")
```