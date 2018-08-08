
library(dplyr)

# Download datasets
  FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(FileUrl, destfile = "./SmartphoneSourceData.zip")
  unzip("./SmartphoneSourceData.zip")
  
  features <- read.table("./UCI HAR Dataset/features.txt")
  activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
  colnames(activity) <- c("ActivityID", "Activity")


#  Read training set data and associated reference files
  Training_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
  Training_ActivityLabels<- read.table("./UCI HAR Dataset/train/y_train.txt")
  Training_subjects <- read.table ("./UCI HAR Dataset/train/subject_train.txt")

# Read in the test set data and associated reference files
  Test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
  Test_Activitylabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
  Test_subjects <- read.table ("./UCI HAR Dataset/test/subject_test.txt")

# Merge the training and test data sets.
  MergeData <- rbind(Training_set, Test_set)

# Merge the subject and activity reference tables. 
  MergeActivity <- rbind(Training_ActivityLabels, Test_Activitylabels)
  MergeSubjects <- rbind(Training_subjects, Test_subjects)

# Add descriptive labels to the column variables.
  colnames(MergeData) <- features[,2]
  colnames(MergeActivity) <- "ActivityID"
  colnames(MergeSubjects) <- "SubjectID"

# Add in columns to the merged data set.
  Merged_set_wlabels <- cbind(MergeSubjects, MergeActivity, MergeData)

# Extract the measurements of standard deviation and mean.
  SelectedColumns <- grepl("*mean\\(\\)|*std\\(\\)|ActivityID|SubjectID", names(Merged_set_wlabels))
  SelectedData <- Merged_set_wlabels[ , SelectedColumns]

# Change actvity IDs to  descriptive names.
  DiscriptiveData <- merge(SelectedData, activity, by="ActivityID") 
  DiscriptiveData <- DiscriptiveData[, c(2,ncol(DiscriptiveData), 3:(ncol(DiscriptiveData)-1))]


# Create a tidy data set.
  TidyData <- aggregate(.~SubjectID+Activity, DiscriptiveData, mean)
  TidyData <- arrange(TidyData, SubjectID)

# Create text file for TidayData.

  write.table(TidyData, "TidyData.txt", row.names = FALSE, quote = FALSE)
            