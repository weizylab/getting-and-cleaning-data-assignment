
#Load the data
library(plyr)
library(data.table)
library(reshape2)
x_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
activity_labels = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activity_labels) <- c("activityID", "activityType")



# 1. Extract only the measurements on the mean and standard deviation for each measurement. 
extract_features <- grepl("mean|std", features)
X_test = X_test[,extract_features]
X_train = X_train[,extract_features]

# 2. Merge the data
alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(alltrain, alltest)

# 3. tidy.txt
finaldataset$activity <- factor(finaldataset$activity, levels = activity_labels[,1], labels = activity_labels[,2])
finaldataset$subject <- as.factor(finaldataset$subject)
melt_data <- melt(finaldataset, id = c("subject", "activity"))
mean_data <- dcast(melt_data, subject + activity ~ variable, mean)

# save data
write.table(mean_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)
