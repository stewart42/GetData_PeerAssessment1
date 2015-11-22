library(dplyr)
library(reshape2)

rm(list = ls())

# getdata-projectfiles-UCI HAR Dataset.zip into working directory
downloadData <- function() { 
    if (!file.exists("UCIHARDataset.zip")) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCIHARDataset.zip", method = "curl");
        unzip(zipfile = "UCIHARDataset.zip");
    }
}

# Merges the training and the test sets to create one data set.
mergeData <- function()  {
    featuresFile <- file.path("UCI HAR Dataset", "features.txt");
    activityFile <- file.path("UCI HAR Dataset", "activity_labels.txt");
    trainXFile <- file.path("UCI HAR Dataset", "train", "X_train.txt");
    testXFile <- file.path("UCI HAR Dataset", "test", "X_test.txt");
    trainYFile <- file.path("UCI HAR Dataset", "train", "Y_train.txt");
    testYFile <- file.path("UCI HAR Dataset", "test", "Y_test.txt");
    trainSubjectFile <- file.path("UCI HAR Dataset", "train", "subject_train.txt");
    testSubjectFile <- file.path("UCI HAR Dataset", "test", "subject_test.txt");
    
    # read all the files in 
    featuresData <- read.table(featuresFile, col.names=c("id", "name"), as.is = TRUE);
    activityData <- read.table(activityFile, col.names=c("id", "activity"), as.is = TRUE);
    trainXData <- read.table(trainXFile);
    testXData <- read.table(testXFile);
    trainYData <- read.table(trainYFile, col.names = 'activity');
    testYData <- read.table(testYFile, col.names = 'activity');
    trainSubjectData <- read.table(trainSubjectFile); 
    testSubjectData <- read.table(testSubjectFile);
    
    # merge x, y and subject data
    testdata <- cbind(testXData, factor(testYData$activity, levels = activityData$id, labels = activityData$activity), testSubjectData);
    traindata <- cbind(trainXData, factor(trainYData$activity, levels = activityData$id, labels = activityData$activity), trainSubjectData);
    # name columns using features file and append names for the 3 additional columns
    names(testdata) <- append(featuresData$name, c("activity", "subject_id"))
    names(traindata) <- append(featuresData$name, c("activity", "subject_id"))
    # merge test and train data
    data <- rbind(testdata, traindata);
    names(data) <- make.names(names = names(data), unique = TRUE, allow_ = TRUE);
    
    data;
}

# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
cleanData <- function(rawData) {
    data <- select(rawData, subject = subject_id, activity, contains("std"), contains("mean"));
    names(data) <- gsub("\\.", names(data), replacement="");
    
    data;
}


# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData <- function (cleanData) {
    # performing average calculation for each group
    meltdata <- melt(cleanData, id = c("subject", "activity"));
    dcast(meltdata, subject + activity ~ variable, mean);
}


downloadData();
data <- mergeData();
data <- cleanData(data);
tData <- tidyData(data);
write.table(tData, file = "tidy_data.txt", sep=" ", quote = FALSE, row.names = FALSE);
