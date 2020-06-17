# -----------------------------------------------------------------------------
# Submission includes: 
# 1) run_analysis.R  - contains the script to perform the data cleaning up
# 2) tidyDataSet.txt - contains tity data set
# 3) CodeBook.md     - describes the variables, data, and work performed 
# 4) README.md       - explains how the scripts work and how they are connected
# -----------------------------------------------------------------------------

## Include the needed libraries
library(dplyr)
library(stringr)

# Clear the workspace to start from fresh
rm(list=ls())


# ----------------------------------------------------------------------------
# 1. Merges the training and the test sets to create one data set.

## Download and unzip data set
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./UCIHARDataset.zip", method="curl")
unzip(".\\UCIHARDataset.zip", exdir=".")

## Read activity labels table
file <- ".\\UCI HAR Dataset\\activity_labels.txt"
activity_labels <- read.table(file, header = FALSE, sep = "")

## Read features table and tidy the feature names
file <- ".\\UCI HAR Dataset\\features.txt"
features <- read.table(file, header = FALSE, sep = "")
feature_labels <- features$V2


## Read the files in the "train" folder
file <- ".\\UCI HAR Dataset\\train\\subject_train.txt"
subject_train <- read.table(file, header = FALSE, sep = "")

file <- ".\\UCI HAR Dataset\\train\\X_train.txt"
X_train <- read.table(file, header = FALSE, sep = "")

file <- ".\\UCI HAR Dataset\\train\\y_train.txt"
y_train <- read.table(file, header = FALSE, sep = "")


## Read the files in the "test" folder
file <- ".\\UCI HAR Dataset\\test\\subject_test.txt"
subject_test <- read.table(file, header = FALSE, sep = "")

file <- ".\\UCI HAR Dataset\\test\\X_test.txt"
X_test <- read.table(file, header = FALSE, sep = "")

file <- ".\\UCI HAR Dataset\\test\\y_test.txt"
y_test <- read.table(file, header = FALSE, sep = "")


## Combine rows in train and test
subject <- rbind(subject_train, subject_test)
x <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)

## Combine subject, y and x into one data set
df <- cbind(subject, y, x)

## Set names for the data frame
df <- setNames(df, c("subject","ACT", feature_labels))

dim(df)

# ----------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement.

## Select the subject, ACT and all the columns with mean() and std()
df <- select(df, grep("subject",  names(df), fixed=TRUE),
                 grep("ACT",      names(df), fixed=TRUE),
                 grep("mean()",   names(df), fixed=TRUE), 
                 grep("std()",    names(df), fixed=TRUE))

dim(df)

# ----------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set
#

### Give same column name "ACT" to the activity number column
activity_labels <- setNames(activity_labels, c("ACT", "activity"))

## Join the two table, the "activity" column will be created
df <- inner_join(df, activity_labels, by="ACT")

## Remove column "ACT" and put "activity" column first
df1 <- select(df, subject, activity, )
df2 <- select(df, -ACT, -subject, -activity)
df <- cbind(df1, df2)

dim(df)

# ----------------------------------------------------------------------------
# 4. Appropriate labels the data set with descriptive variable names.
#

dfNames <- names(df)

## Replace "mean" with "Mean"
dfNames <- gsub("mean", "Mean", dfNames)

## Replace "std" with "Std"
dfNames <- gsub("std", "Std", dfNames)

## Remove all the special characters
dfNames <- str_replace_all(dfNames, "[[:punct:]]", "")

# Assign the new label to the data set
colnames(df) <- dfNames

dim(df)

# ----------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
#

tidyDataSet <- aggregate(df[,3:ncol(df)], list(df$subject, df$activity), mean)
names(tidyDataSet)[1] <- "subject"
names(tidyDataSet)[2] <- "activity"

dim(tidyDataSet)

# ----------------------------------------------------------------------------
# 6. Write the data out to a tidy data file

write.table(tidyDataSet, file = "tidyDataSet.txt", row.name=FALSE)


