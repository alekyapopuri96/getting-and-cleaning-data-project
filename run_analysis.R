#### preparing the data ####
###download the data and unzip it ####

download <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  ",destfile = "download.zip")
unzip<- unzip("download.zip")

##collecting and storing the features and test and train data

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

##merging the training and testing data

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(train_subject, test_subject)
MergeData <- cbind(Subject, Y, X)

## extracting the mean and standard deviation

Tidy <- MergeData %>% select(subject, code, contains("mean"), contains("std"))

Tidy$code <- activities[Tidy$code, 2]

####labeling the variables

names(Tidy)[2] = "activity"
names(Tidy)<-gsub("Acc", "Accelerometer", names(Tidy))
names(Tidy)<-gsub("Gyro", "Gyroscope", names(Tidy))
names(Tidy)<-gsub("BodyBody", "Body", names(Tidy))
names(Tidy)<-gsub("Mag", "Magnitude", names(Tidy))
names(Tidy)<-gsub("^t", "Time", names(Tidy))
names(Tidy)<-gsub("^f", "Frequency", names(Tidy))
names(Tidy)<-gsub("tBody", "TimeBody", names(Tidy))
names(Tidy)<-gsub("-mean()", "Mean", names(Tidy), ignore.case = TRUE)
names(Tidy)<-gsub("-std()", "StandardDeviation", names(Tidy), ignore.case = TRUE)
names(Tidy)<-gsub("-freq()", "Frequency", names(Tidy), ignore.case = TRUE)
names(Tidy)<-gsub("angle", "Angle", names(Tidy))
names(Tidy)<-gsub("gravity", "Gravity", names(Tidy))


##creating tidy.txt file

FinalTidyData <- Tidy %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalTidyData, "tidy.txt", row.name=FALSE)









