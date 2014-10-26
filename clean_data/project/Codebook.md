---
title: "Codebook"
author: "Ari"
date: "Monday, October 27, 2014"
output: html_document
---

run_analysis.R creates a tidy data set with the average of each variable for each activity and each subject. It has 68 variables.

```{r}
length(names(tidy))
```


The first two are Subject and Activity. The rest are averages of each variable for each activity and and each subject.

```{r}
str(tidy)
```

The following packages must be present.

```{r}
library(httr); 
library(httpuv); 
library(data.table); 
library(dplyr); 
```

