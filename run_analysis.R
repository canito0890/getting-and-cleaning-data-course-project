# Getting and Cleaning Data Project
# run_analysis.R file
# Complete project script

# Load dependencies
print("Loading reshape2...")
library(reshape2)

# Obtain data
zipName <- "data.zip"
dataDir <- "UCI HAR Dataset"
# Download data and uncompress if it does not exist
if(!file.exists(zipName)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  print("Downloading data...")
  download.file(fileURL, zipName, method = "curl")
}
if(!file.exists(dataDir)){ 
  cat("Uncompressing data...", zipName, "\n")
  unzip(zipName)
}else{
  cat("Data already in Working Directory: ", dataDir, "\n")
}

# Read datasets, activities and features
# Train data
print("Reading training data...")
train.features <- read.csv(paste(dataDir,"train/X_train.txt", sep = "/"), sep = "", header = FALSE)
train.activities <- read.csv(paste(dataDir,"train/y_train.txt", sep = "/"), sep = "", header = FALSE)
train.subjects <- read.csv(paste(dataDir,"train/subject_train.txt", sep = "/"), sep = "", header = FALSE)

# Test data
print("Reading test data...")
test.features <- read.csv(paste(dataDir,"test/X_test.txt", sep = "/"), sep = "", header = FALSE)
test.activities <- read.csv(paste(dataDir,"test/y_test.txt", sep = "/"), sep = "", header = FALSE)
test.subjects <- read.csv(paste(dataDir,"test/subject_test.txt", sep = "/"), sep = "", header = FALSE)

# Read activity labels
print("Reading actvity labels...")
activities <- read.table(paste(dataDir,"activity_labels.txt", sep = "/"))

# Read features
print("Reading features...")
features <- read.table(paste(dataDir,"features.txt", sep = "/"))[,2]
# Only mean and standard deviation features via regexp
features.usable <- grep(".*mean.*|.*std.*", features)
# Tidy feature names
features <- gsub('-mean', 'Mean', features)
features <- gsub('-std', 'Std', features)
features <- gsub('[-()]', '', features)
# Remove other features
features <- features[features.usable]

# Merge datasets
print("Merging datasets...")
# Merge training data
train <- cbind(train.subjects, train.activities, train.features[features.usable])
# Merge test data
test <- cbind(test.subjects, test.activities, test.features[features.usable])
# Merge both datasets
data.merged <- rbind(train, test)

# Prepare merged data for analysis
print("Preparing data...")
# Add readable column names
colnames(data.merged) <- c("Subject", "Activity", features)
# Factors
data.merged$Activity <- factor(data.merged$Activity, levels = activities[,1], labels = activities[,2])

# Melt and cast data with reshape2
print("Melting and casting merged data...")
# Melt
data.melted <- melt(data.merged, id = c("Subject", "Activity"))
# Dcast
data.dcasted <- dcast(data.melted, Subject + Activity ~ variable, mean)

# Write to new file
print("Writing tidy data to file...")
head(data.dcasted)
write.table(data.dcasted, "result.txt", row.names = FALSE, quote = FALSE)
