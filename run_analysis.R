# read activities
activities <- read.table("D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/activity_labels.txt")
activities[,2] <- as.character(activities[,2])

# read features
features <- read.table("D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# read X files
xTest <- read.table("D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
xTrain <- read.table("D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/train/x_train.txt", stringsAsFactors = FALSE)

# name colums as seen in features
colnames(xTest) <- features$V2
colnames(xTrain) <- features$V2

# combine X data
xCombined <- rbind(xTest, xTrain)

# read Y files
yTest <- read.table("D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/test/Y_test.txt",  stringsAsFactors = FALSE)
yTrain <- read.table("D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/train/Y_train.txt",  stringsAsFactors = FALSE)

# name columns as -activity-
colnames(yTest) <- c("activity")
colnames(yTrain) <- c("activity")

# combine Y data
yCombined <- rbind(yTest, yTrain)

# read subject files
subTest <- read.table("D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/test/subject_test.txt",  stringsAsFactors = FALSE)
subTrain <- read.table("D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/train/subject_train.txt",  stringsAsFactors = FALSE)

# subjects numbers
colnames(subTest) <- c("number")
colnames(subTrain) <- c("number")

# combine subject data
subCombined <- rbind(subTest, subTrain)

# 1. Merges the training and the test sets to create one data set.
allData <- cbind(xCombined, yCombined, subCombined)

# remove redundant data
remove(xTest)
remove(xTrain)
remove(yTest)
remove(yTrain)
remove(subTest)
remove(subTrain)
remove(xCombined)
remove(yCombined)
remove(subCombined)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanAndStd <- grep(".*mean.*|.*std.*", features[,2])
allDataMeanAndStd <- allData[, meanAndStd]

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
allData$activity <- factor(allData$activity, levels = activities$V1, labels = activities$V2)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
allData2 <- lapply(X=labels, FUN=function(x) tapply(allData[[x]], list(allData$activity, allData$number), mean))

# write result into a file
write.table(allData, "D:/X/Data-Science-Specialization/03-Getting-and-Cleaning-Data/DataFiles/UCI HAR Dataset/assignment_results.txt")
