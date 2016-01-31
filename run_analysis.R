#
# Check to see if the requested library x is installed. If it is not installed,
# install it, then load it. If it is installed, load the library.
#
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
  library(x, character.only = TRUE)
}


#
# Reformat some of the abbreviated text used for the column labels
# Add additional lines for making changes as needed.
#
cleanLabels <- function(x)
{
  tmp <- sub('tBodyAcc','time.Body.Acceleration',x)
  tmp <- as.character(gsub('tGravityAcc','time.Gravity.Acceleration',tmp))
  tmp <- as.character(gsub('fBodyAcc','frequenct.Body.Acceleration',tmp))
  tmp <- as.character(gsub('fBody','frequency.Body.',tmp))
  tmp <- as.character(gsub('tBody','time.Body.',tmp))
  tmp <- as.character(gsub('-','.',tmp))
  tmp <- as.character(gsub('[()]','',tmp))
  tmp
  }


#
# Load the desired libraries
#
pkgTest('readr')
pkgTest('dplyr')
pkgTest('tidyr')


##
## Load the file containing the list of activities tracked, along with their corresponding ID
## activity.ID - id of activity
## activity.Description - Name of activity
##
activity.labels.df <- tbl_df(read_table('data/activity_labels.txt', c('activity.ID','activity')))


##
## Load file containing labels for the data columns
## Then separate the data into two columns: an ID and the name of the column
## column.ID - contains the ID corresponding to the column name
## column.Description - contains the text for the name of the column
##
features.txt <- read_table('data/features.txt', 'colNames')
data.columns.labels.df <- tbl_df(separate(features.txt, colNames ,c('column.ID','columnDescription'), sep='\\ '))
rm(features.txt)


##
## Load Training Data
##
## Load the subject list for the training data
subjects.train.df <- tbl_df(read_table('data/train/subject_train.txt','subject'))
## Load the activity associated with each observation of the training data
activity.train.df <- tbl_df(read_table('data/train/y_train.txt', 'activity.ID'))
## Load the training data
training.data.df <- tbl_df(read_table('data/train/X_train.txt', col_names = FALSE))


##
## Load Test Data
##
## Load the subject list for the test data
subjects.test.df <- tbl_df(read_table('data/test/subject_test.txt','subject'))
## Load the activity associated with each observation of the test data
activity.test.df <- tbl_df(read_table('data/test/y_test.txt', 'activity.ID'))
## Load the training data
test.data.df <- tbl_df(read_table('data/test/X_test.txt',col_names = FALSE))


##
## Assign subjects to each row of the datasets. 
## NOTE: We are assuming that each row of the subject dataset maps to the same row in the corresponding
## training or test dataset.
training.data.df <- cbind(subjects.train.df, training.data.df)
test.data.df <- cbind(subjects.test.df, test.data.df)
rm(subjects.train.df, subjects.test.df)


##
## Assign activity labels to each row of the datasets
training.data.df <- cbind(activity.train.df, training.data.df)
test.data.df <- cbind(activity.test.df, test.data.df)
rm(activity.train.df, activity.test.df)


##
## Combine test and train data sets into one dataset
##
master.dataset.df <- rbind(training.data.df, test.data.df)
rm(training.data.df, test.data.df)


## Use the columnDescription values to create descriptive variable names for the data set.
## Due to the prior manipulations for adding the activity ID, we already have a fairly descriptive
## variable name defined, so we will start naming the data columns with the second column
names(master.dataset.df)[3:ncol(master.dataset.df)] <- c(data.columns.labels.df$columnDescription)
rm(data.columns.labels.df)

## Merge the activity labels dataframe to the data set. This maps the approrpiate activity decription
## to the activity ID of the row.
master.dataset.df <- merge(activity.labels.df, master.dataset.df, by.x='activity.ID', by.y='activity.ID')
rm(activity.labels.df)


##
## Subset only those columns that are the means and standard deviations of the variables tracked
##
#master.subset.df <- master.dataset.df[ , grepl('activity$|subject$|mean[()]|std[()]', names(master.dataset.df)) ]
msdf <- master.dataset.df[ , grepl('activity$|subject$|mean[()]|std[()]', names(master.dataset.df)) ]
rm(master.dataset.df)


##
## Let's clean up the column labels.
## Use the function cleanLabels to reformat some of the text
##
columnLabelText <- names(msdf)
#dfx <- apply(data.columns.labels.df[,2],2,cleanLabels)
columnLabelText <- sapply(columnLabelText,FUN=cleanLabels, USE.NAMES = FALSE)
names(msdf) <- columnLabelText
rm(columnLabelText)


##
## Summarize the variable data by subject, then by activity within subject
## Calculate the mean
##
msdf.summ <- group_by(msdf, subject, activity) %>% summarise_each(funs(mean))

