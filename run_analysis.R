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
  setwd(datapath)
  tmp <- read.table(filename)
  setwd(currdir)
  print(paste('file loaded: ', filename))
  tmp
}

pkgTest('dplyr')
pkgTest('tidyr')

library(dplyr)
library(tidyr)

activities <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/','activity_labels.txt')
features <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/','features.txt')
subjects_train <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/train/','subject_train.txt')
subject_activity_train <-load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/train/', 'y_train.txt')
#data_train <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/train/', 'X_train.txt')
subjects_test <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/test/','subject_test.txt')
subject_activity_ttest <-load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/test/', 'y_test.txt')
#data_test <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/test/', 'X_test.txt')

print(left_join(subjects_train, subject_activity_train, by='V1'))
