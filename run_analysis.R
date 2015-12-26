pkgTest <- function(x)
{
  #
  # this routine came from a solution in stackoverflow
  # http://stackoverflow.com/questions/9341635/check-for-installed-packages-before-running-install-packages
  #
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

load_data <- function(datapath, filename) {
  currdir = getwd()
  newdir = paste(currdir,'/',datapath, sep='')
  setwd(newdir)
  tmp <- read_table(filename, col_names = FALSE)
  setwd(currdir)
  print(paste('file loaded: ', filename))
  tmp
}


pkgTest('readr')
pkgTest('dplyr')
pkgTest('tidyr')

library(readr)
library(dplyr)
library(tidyr)

rm(master.dataset.df)
rm(activity.labels.df, features.txt, data.columns.labels.df, subjects.test.df, subjects.train.df, activity.test.df, activity.train.df, training.data.df, test.data.df)


##
## Load the file containing the list of activities tracked, along with their corresponding ID
## activity.ID - id of activity
## activity.Description - Name of activity
##
activity.labels.df <- read_table('data/activity_labels.txt', c('activity.ID','activity.Description'))

##
## Load file containing labels for the data columns
## Then separate the data into two columns: an ID and the name of the column
## column.ID - contains the ID corresponding to the column name
## column.Description - contains the text for the name of the column
##
features.txt <- read_table('data/features.txt', 'colNames')
data.columns.labels.df <- separate(features.txt, colNames ,c('column.ID','columnDescription'), sep='\\ ')

##
## Load Training Data
##
## Load the subject list for the training data
subjects.train.df <- read_table('data/train/subject_train.txt','subject.ID')
## Load the activity associated with each observation of the training data
activity.train.df <- read_table('data/train/y_train.txt', 'activity.ID')
## Load the training data
training.data.df <- read_table('data/train/X_train.txt', col_names = FALSE)

##
## Load Test Data
##
## Load the subject list for the test data
subjects.test.df <- read_table('data/test/subject_test.txt','subject.ID')
## Load the activity associated with each observation of the test data
activity.test.df <- read_table('data/test/y_test.txt', 'activity.ID')
## Load the training data
test.data.df <- read_table('data/test/X_test.txt',col_names = FALSE)

##
## Assign activity labels to each row of the datasets

training.data.df <- cbind(activity.train.df, training.data.df)
test.data.df <- cbind(activity.test.df, test.data.df)

##
## Combine test and train data sets into one dataset
##

master.dataset.df <- rbind(training.data.df, test.data.df)
names(master.dataset.df) <- c('activity.ID', data.columns.labels.df$columnDescription)
master.dataset.df <- merge(activity.labels.df, master.dataset.df, by.x='activity.ID', by.y='activity.ID')

## Remove the activity ID column, we only need the text label to 
## identify the activity
master.dataset.df <- subset(master.dataset.df, select=-c(activity.ID))
View(master.dataset.df)

##
## Assign descriptive column names for the data
##
## Take the column.Description column from the
## data.columns.labels.df and assign the values of this column
## as name values for the master dataset columns. The assumption here is
## that the ordering of the data in data.column.labels.df is a one-to-one
## mapping to the columns in the dataset eg item 1 of data.columns.labels.df maps
## to the first variable in the master data set.
##
#names(master.dataset.df) <- data.columns.labels.df$columnDescription


# rm(master.dataset.df)
# rm(activity.labels.df, features.txt, data.columns.labels.df, subjects.test.df, subjects.train.df, activity.test.df, activity.train.df, training.data.df, test.data.df)
