## Course Project 2, Getting and Cleaning Data
## Grant Oliveira 1/25/15
## Step 0: Load and Define All Files
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
trainingSet <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
Features <- read.table("./UCI HAR Dataset/features.txt", sep="", stringsAsFactors=FALSE)
ActivityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep="")
TestActivities <- read.table("./UCI HAR Dataset/test/y_test.txt", sep="", stringsAsFactors=FALSE)
TrainActivities <- read.table("./UCI HAR Dataset/train/y_train.txt", sep="", stringsAsFactors=FALSE)
SubjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")
SubjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")

## Step 1: Merge Training and Test, Subjects, Activities
TrainTest <- rbind(testSet, trainingSet)
activity <- rbind(TrainActivities,TestActivities)
subject <- rbind(SubjectTrain,SubjectTest)
FeaturesNames <- Features[,2]
colnames(TrainTest) <- FeaturesNames
ActSub <- cbind(subject,activity)
colnames(ActSub) <- c("subject","activity")

## Step 2: Extract Only mean, std or activityLabel, add Subject and Activity
Data <- TrainTest[,grep("mean|std|activityLabel",FeaturesNames)]
Data <- cbind(Data,ActSub)


## Step 3: Clean ColNames
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("-meanFreq()", "Mean", names(Data))
names(Data)<-gsub("-std()", "STD", names(Data))

## Step 4: Create Second Second Tidy Dataset
library(plyr);
tidyData <- aggregate(. ~subject + activity, Data, mean)
tidyData <- tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file="tidydata.txt", row.name=FALSE)

## Step 5: Head to the Winchester, Grab a Pint, Wait for this All to Blow Over
