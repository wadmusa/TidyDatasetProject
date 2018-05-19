# 1. Download the Tidy dataset and unzip the file

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="UCI HAR Dataset.zip", method="curl")
unzip(zipfile="C:/Data/TidyData.zip",exdir="C:/Data")
list.files("C:/Data")
DataDir = file.path("C:/Data", "UCI HAR Dataset")
files = list.files(DataDir, recursive=TRUE)
files

# 2. Create traing set and testing set

Xtrain = read.table(file.path(DataDir, "train", "X_train.txt"),header = FALSE)
Ytrain = read.table(file.path(DataDir, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(DataDir, "train", "subject_train.txt"),header = FALSE)


Xtest = read.table(file.path(DataDir, "test", "X_test.txt"),header = FALSE)
Ytest = read.table(file.path(DataDir, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(DataDir, "test", "subject_test.txt"),header = FALSE)

features = read.table(file.path(DataDir, "features.txt"),header = FALSE)

activityLabels = read.table(file.path(DataDir, "activity_labels.txt"),header = FALSE)

# Creat Columns

colnames(Xtrain) = features[,2]
colnames(Ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#Create Sanity and column values to the test data
colnames(Xtest) = features[,2]
colnames(Ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')

# Merging the train set and the test set 
merge_train = cbind(Ytrain, subject_train, Xtrain)
merge_test = cbind(Ytest, subject_test, Xtest)
#Create the main data table merging both table tables 
OneDataSet = rbind(merge_train, merge_test)

# Read all the values that are available
colNames = colnames(OneDataSet)
#A subset of all the mean and standards and the correspondongin activityID and subjectID 
Mean_Std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
MeanAndStd <- OneDataSet[ , Mean_Std == TRUE]

DataSetWithActivityNames = merge(MeanAndStd, activityLabels, by='activityId', all.x=TRUE)

TidyDataSet <- aggregate(. ~subjectId + activityId, DataSetWithActivityNames, mean)
TidyDataSet <- TidyDataSet[order(TidyDataSet$subjectId, TidyDataSet$activityId),]

write.table(TidyDataSet, "TidyDataSet.txt", row.name=FALSE)