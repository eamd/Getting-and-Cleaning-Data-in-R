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

## Use the columnDescription values to create descriptive variable names for the data set.
## Due to the prior manibulations for adding the activity ID, we already have a failry descriptive
## variable name defined, so we will start naming the data columns with the second column
names(master.dataset.df)[2:ncol(master.dataset.df)] <- c(data.columns.labels.df$columnDescription)

## Merge the activity labels dataframe to the data set. This maps the approrpiate activity decription
## to the activity ID of the row.
master.dataset.df <- merge(activity.labels.df, master.dataset.df, by.x='activity.ID', by.y='activity.ID')

## Remove the activity ID column, we only need the text label to 
## identify the activity
master.dataset.df <- subset(master.dataset.df, select=-c(activity.ID))

##
## Subset only those columns that are the means and standard deviations of the variables tracked
##
master.subset.df <- master.dataset.df[ , grepl('activity.Description$|mean[()]|std[()]', names(master.dataset.df)) ]



