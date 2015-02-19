##R Project for Coursera Getting and Cleansing Data
##Download files
library(dplyr)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//project.zip")
## read in the tables 
X_test <- "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//UCI HAR Dataset//test//X_test.txt"
X_testread <- read.table(X_test)
y_test <- "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//UCI HAR Dataset//test//y_test.txt"
y_testread <-read.table(y_test)
subject_test <- "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//UCI HAR Dataset//test//subject_test.txt"
subject_testread <-read.table(subject_test)
X_train <- "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//UCI HAR Dataset//train//X_train.txt"
X_trainread <- read.table(X_train)
y_train <- "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//UCI HAR Dataset//train//y_train.txt"
y_trainread <-read.table(y_train)
subject_train <- "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//UCI HAR Dataset//train//subject_train.txt"
subject_trainread <-read.table(subject_train)
features <- "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//UCI HAR Dataset//features.txt"
featuresread <-read.table(features)
activity_labels <- "C://Users//z003db5u//Desktop//BI and Analytics Studying//Data Science - John Hopkins-Coursera//Getting and Cleaning Data - Course 3//Course Project//UCI HAR Dataset//activity_labels.txt"
activity_labelsread <-read.table(activity_labels)



##go ahead and get just those columns we want from each
l = c("mean", "std") ##sets up a charactor vector of text to search from
meanstd <- subset(featuresread, grepl(paste(l, collapse="|"),featuresread$V2),1)
## subsets the rows in the featuresread file and select only those rows with mean or std in the name
meanstd2 <- meanstd[,] ## turns this into a single char vector
test_xmeanstd <- subset(X_testread, select = meanstd2)
## subsets the x_test read file and just grabs columns with mean and std
train_xmeanstd <- subset(X_trainread,select=meanstd2)
## subsets the x_train read file and just grabs columns with mean and std
test_full1 <- cbind(test_xmeanstd, y_testread, subject_testread)
train_full1 <- cbind(train_xmeanstd, y_trainread, subject_trainread)
## two steps above cbind the different data steps 
mergednonames <- rbind(test_full1, train_full1)
##
##set up the names to apply to merged no names headers
meanstd3 <- subset(featuresread, grepl(paste(l, collapse="|"),featuresread$V2),2)
## gets all of the column names from the featuresread data set
meanstd4 <- as.character(meanstd3[,1])
##grabs only the names and makes them characters so we can make list
systemnames <- make.names(meanstd4, unique= TRUE)


initialnames <- c(systemnames,"Activity", "Subject")
## concatenates so we now have a list of names to replace
colnames(mergednonames) <- initialnames
## sets colnames to the intialcolumn names 
## now mergednonames really has names so lets just subset to initialnames
initialnameswithdata <- subset(mergednonames)
Datawithnames <- merge(initialnameswithdata,activity_labelsread, by.x= "Activity", by.y="V1", all = TRUE)
Datawithnamesupdate <- select(Datawithnames,-(Activity))
Datawithnamesupdate2 <- rename(Datawithnamesupdate, Activity = V2)
datagroups <- group_by(Datawithnamesupdate2, Subject, Activity)

finaldata <- summarise_each (datagroups, funs(mean))

