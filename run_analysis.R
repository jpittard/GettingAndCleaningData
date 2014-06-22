## This is the whole process.
run_analysis <- function() {
	
	## Download and unpack the data.
	getData()
	
	## Merge it into a single dataset
	setwd("./UCI HAR Dataset")
	merged <- mergeTrainingAndTest()
	
	## Write out the averages per activity and subject.
	setwd("..")
	write.table(getAverages(merged), file="tidy.txt", 
		    quote=FALSE, row.names=FALSE, col.names=TRUE)
}


getData <- function() {
	fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	dateDownloaded <- date()
	dateDownloaded
	download.file(fileUrl, destfile = "UCI_HAR_Dataset.zip", method = "curl")
	unzip("UCI_HAR_Dataset.zip")
}


## Merge the training and the test sets to create one data set.
mergeTrainingAndTest <- function() {
	
	features   <- read.delim("features.txt"       , sep = " ", header=FALSE)
	activities <- read.delim("activity_labels.txt", sep = " ", header=FALSE)
	
	subjectTest  <- read.delim("test/subject_test.txt"  , header=FALSE)
	subjectTrain <- read.delim("train/subject_train.txt", header=FALSE)
	yTest        <- read.delim("test/y_test.txt"        , header=FALSE)
	yTrain       <- read.delim("train/y_train.txt"      , header=FALSE)
	
	## Extract only the measurements on the mean and standard deviation for 
	## each measurement. 
	features$keep <- grepl("std\\(\\)|mean\\(\\)", features$V2)
	colNames <- gsub("()", "", features[features$keep, "V2"], fixed=TRUE)
	
	## Set negative widths to skip reading unwanted columns.
	features$width <- ifelse(features$keep, 16, -16)
	
	## All columns are numeric
	colClasses <- rep("numeric", length(colNames))
	
	xTest <- read.fwf("test/X_test.txt", widths=features$width, 
		colClasses=colClasses, nrows=2947, 
		col.names=colNames)
	xTrain <- read.fwf("train/X_train.txt", widths=features$width, 
		colClasses=colClasses, nrows=7352, 
		col.names=colNames)
	
	## Merge in the subjects
	xTest$subject  <- subjectTest$V1
	xTrain$subject <- subjectTrain$V1

	## Use descriptive activity names to name the activities in the data set
	xTest$activity  <- merge(yTest , activities, by="V1")[, "V2"]
	xTrain$activity <- merge(yTrain, activities, by="V1")[, "V2"]
	
	## Differentiate the datasets for after they are combined
	xTest$dataset  <- "TEST"
	xTrain$dataset <- "TRAINING"

	rbind(xTest, xTrain)
}

## Create a second, independent tidy data set with the average of each variable 
## for each activity and each subject. 
getAverages <- function(merged) {
	
	avgs <- aggregate(merged, by=list(merged$activity,merged$subject), FUN=mean)
	
	## Remove the columns that are unused in the aggregate
	avgs$activity <- avgs$dataset <- avgs$subject <- NULL
	
	## Rename the group columns
	colnames(avgs)[1:2] <- c("Activity","Subject")
	
	## Order the columns so the aggregate is apparent
	avgs[order(avgs$Activity, avgs$Subject),]
}

