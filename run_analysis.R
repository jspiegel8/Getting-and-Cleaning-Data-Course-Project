##R Project for Coursera Getting and Cleansing Data

##Step 1 - load R packages to be used, download files, and read tables
##
library(dplyr) ##loads the dplyr package
##Download files
## downloads the zip file

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Samsung.zip")
unzip("Samsung.zip")
## at this time my computer denied my access to the zip, so i manually dowlnoaded
## and set the location to the file location where I read in the files

## read in the tables 
X_test <- read.table(".//UCI HAR Dataset//test//X_test.txt")
y_test <- read.table(".//UCI HAR Dataset//test//y_test.txt")
subject_test <- read.table(".//UCI HAR Dataset//test//subject_test.txt")
X_train <- read.table(".//UCI HAR Dataset//train//X_train.txt")
y_train <- read.table(".//UCI HAR Dataset//train//y_train.txt")
subject_train <- read.table(".//UCI HAR Dataset//train//subject_train.txt")
features <- read.table(".//UCI HAR Dataset//features.txt")
activity_labels <- read.table(".//UCI HAR Dataset//activity_labels.txt")

## Step 2 - Getting only data with column names having mean or std in them
##start process to get only columns associated with mean and std dev
## chose to go with all variables with mean and std dev present
## chose this route because it is not a manual process of choosing
## variables and works off logic and R programming. 
##sets up a charactor vector of text to search from
l = c("mean", "std") 
## subsets the rows in the features file and select only those rows with mean or std in the name
meanstd <- subset(features, grepl(paste(l, collapse="|"),features$V2),1)
## subsets the meanstd data set and turns this into a single char vector
meanstd2 <- meanstd[,] 
## subsets the x_test  file and just grabs columns with mean and std
test_xmeanstd <- subset(X_test, select = meanstd2)
## subsets the x_train  file and just grabs columns with mean and std
train_xmeanstd <- subset(X_train,select=meanstd2)

## Step 3 - Column binding and concatenating 
## adds the activity and subject columns to the data set by column binding
test_full1 <- cbind(test_xmeanstd, y_test, subject_test)
train_full1 <- cbind(train_xmeanstd, y_train, subject_train)
## concatenates the data sets together (one on top of another) to make a full dataset
mergednonames <- rbind(test_full1, train_full1)


##Step 4 - Changing Names
## gets all of the column names from the features data set
meanstd3 <- subset(features, grepl(paste(l, collapse="|"),features$V2),2)
##grabs only the names and makes them characters so we can make list
meanstd4 <- as.character(meanstd3[,1])
##makes names that are systematic, do this so that we can perform the summarize function later on
systemnames <- make.names(meanstd4, unique= TRUE)
## concatenates so we now have a list of names to replace, which includes our new systematic names
initialnames <- c(systemnames,"Activity", "Subject")
## sets colnames to the intialcolumn names 
colnames(mergednonames) <- initialnames
## now mergednonames really has names so lets just subset to initialnames
## this is an extra fluff step but it didnt make sense to have
## this data be called mergednonames when it really has our names
initialnameswithdata <- subset(mergednonames)
## merges the activty label names (descriptive names) with the number code
## therefore it gets the names walking up, walking etc, instead of 1, 2
Datawithnames <- merge(initialnameswithdata,activity_labels, by.x= "Activity", by.y="V1", all = TRUE)
## deletes out the extra column, our original column called activity
Datawithnamesupdate <- select(Datawithnames,-(Activity))
## renames our V2 (the new activity with descriptions) to activity
Datawithnamesupdate2 <- rename(Datawithnamesupdate, Activity = V2)


##Step 5 - Group, summary, and output
## groups by subject and activity for step 5
datagroups <- group_by(Datawithnamesupdate2, Subject, Activity)
## summaries each group by above by mean to complete step 5
finaldata <- summarise_each (datagroups, funs(mean))
## writes to a text file to be submitted for project
FinalTabletxt <- write.table(finaldata, ".//projectgettingandcleaningtxtoutput.txt", row.name = FALSE) 

##done