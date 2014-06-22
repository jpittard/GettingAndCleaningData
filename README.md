README for run_analysis.R
========================================================
The main function, run_analysis(), will perform all the steps needed to 
download the data, merge it into a single data frame, and then write out a second
dataset with 
averages per activity and subject into a new datafile called "tidy.txt". That 
file can then be read in as space-separated text.

```{r}
run_analysis()
avgs <- read.delim("tidy.txt", sep=" ", header=TRUE)
```

The data were collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data are downloaded from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Please see codebook.txt for a description of columns
