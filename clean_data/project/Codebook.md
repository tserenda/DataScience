---
title: "Codebook"
author: "Ari"
date: "Monday, October 27, 2014"
output: html_document
---

<h3>Prerequisites</h3>
There is no requirements for the script to run. If "plyr" package is not installed, the script installs and loads it. If the Samsung data is not present, the script will download and unzip the data.

<h3>Information About Variables</h3>
There are 68 variables of which the first two are as follows:<br>
Subject: an integer variable between 1 and 30 identifying the subject who participated in the study<br>
Activity: a factor variable that is one of six different activities that test subjects were asked to perform in the study:<br>
<ul>
    <li>Walking</li>
	<li>Walking Upstairs</li>
	<li>Walking Downstairs</li>
	<li>Sitting</li>
	<li>Standing</li>
	<li>Laying</li>
</ul>

The rest of the variables are numeric, prefixed with "Mean" denoting the mean of the underlying variable; for example, "Mean-tBodyAcc-mean()-X" is the mean of "tBodyAcc-mean()-X" variable.<br>

<h3>Information About Summary Choices</h3>
Please see features_info.txt in the Samsung data for details.

<h3>Experimental / Study Design</h3>
Please see README.txt in the Samsung data for details about the experimental design conducted by Reyes-Ortiz et al.

<h3>run_analysis.R script logic</h3>
<ol>
    <li>Load or install required packages.</li>
	<li>Create and set a working directory for the project</li>
	<li>Download and extract Samsung data files</li>
	<li>Read the data files into R</li>
	<li>cbind() datasets from X_test.txt, y_test.txt and subject_test.txt.</li>
	<li>cbind() datasets from X_train.txt, y_train.txt and subject_train.txt.</li>
	<li>rbind() test and train datasets.</li>
	<li>Apply variable names from features.txt to the combined test and train dataset.</li>
	<li>Apply "Subject" and "Actvity" to the first two columns of the combined test and train dataset.</li>
	<li>Substitute activity names for their codes in the combined test and train dataset.</li>
	<li>Select only those variables that are mean and standard deviation.</li>
	<li>Apply column-wise mean() over the selected variables.</li>
	<li>Write out the tidy dataset.</li>
</ol>

<h3>References</h3>
Samsung data https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
