## Packages
library(readxl)
library(tidyr)
library(dplyr)
library(class)
library(lubridate)

# Source folder
path <- 'C:/Users/gemin/Documents/School Work/Statistical Learning/Data_HomeEx1/'
# Source file
source_animal <- paste(path, "df4_5s.txt", sep = "")

# Import .txt as if it were a csv
df_animal <- read.delim(source_animal,
                        header = TRUE,
                        sep = ",",
                        dec = ".")

# convert timestamp from character to datetime
df_animal$Timestamp <- as.numeric(lubridate::ymd_hms(df_animal$Timestamp))

# remove the rows with missing data
df_animal <- subset(df_animal, Modifiers != "Missing data")

# normalize data
standardized.x <- scale(df_animal[, -53])

# sort out our train-test split
train = 1:(dim(standardized.x)[1] * 0.7)

# split into train/test splits, exclude the class column
train.x <- standardized.x[train, -53]
test.x <- standardized.x[-train, -53]

# prepare all the classes
train.Modifiers <- factor(df_animal$Modifiers[train])
test.Modifiers <- factor(df_animal$Modifiers[-train])

# find elbow point for a knn classifier by repeatedly running the model
error_curve <- list()
for (k in 1:20) {
  # Set random seed before running the classifier to remove random factor
  set.seed(940525)
  knn.pred <- knn(train.x, test.x, train.Modifiers, k = k)
  error_curve <- append(error_curve, mean(test.Modifiers != knn.pred))
}
plot(1:length(error_curve),
     error_curve,
     xlab = "k-value",
     ylab = "Mean error")
# Per the above plot, k=8 seems to be the elbow; however, that's still just 60% accuracy.
set.seed(940525)
knn.pred <- knn(train.x, test.x, train.Modifiers, k = 8)
# Confirm accuracy of final model
mean(test.Modifiers != knn.pred)
