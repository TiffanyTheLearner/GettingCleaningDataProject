---
title: "README"
---

### Files included in this submission

- **run_analysis.R** is the R script used to process the data 
- **tidyDataSet.txt** is the resulting tity data set
- **CodeBook.md** describes the variables, data, and work performed 
- **README.md** explains how the scripts work

### Description of the run_analysis.R script

#### Preparation

- Imported the needed library
- Clear the work space

#### Step 1 

- Download the zip file from the following location

     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

- Extract the files into the folder name "UCI HAR Dataset"

- Read activity labels from activity_labels.txt file

- Read feature labels from features.txt file

- Read subject for train group from subject_train.txt in train folder 

- Read data for train group from X_train.txt in train folder 

- Read activity for train group from y_train.txt in train folder 

- Read subject for test group from subject_test.txt in test folder 

- Read data for test group from X_test.txt in test folder 

- Read activity for test group from y_test.txt in test folder 

- Combine the subject rows for train and test groups

- Combine the data rows for train and test groups

- Combine the activity rows for train and test groups

- Combine the columns of subject, activity and data

- Set column names as "subject", "ACT", and the labels from "feature" 

The output of this step is a [10299, 563] data frame (df). 


#### Step 2

- Use select call to select get a data frame include only the subject, the ACT
  and the columnes with "mean()" and "std()" in the column names.
  
The output of this step is a [10299, 68] data frame (df).


#### Step 3

- First label the "activity labels" table with "ACT" and "activity", where
  "ACT" for the number column and "activity" for the descriptive name column.
  
- Then call inner_join to join the data frame (df) with the "activity labels" 
  by the column named "ACT".  A new column "activity" will be added to data
  frame (df)

- Remove the "ACT" column. 

The output of this step is a [10299, 68] data frame (df) with descriptive activity names


#### Step 4

- Use gsub call to replace all the word "mean" by "Mean"

- Use gsub call to replace all the word "std" by "Std"

- Use str_replace_all call to remove all the "-" and "()" in the names.

The output of this step is a [10299, 68] data frame (df) with appropriate labels


#### Step 5

- Use aggregate by column subject and activity to compute teams for the data 
  columns.

The output of this step is a [180, 68] data frame with tidy data set.

#### Step 6

Write the tidy data set to a file named "tidyDataSet.txt"



