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

#activities <- load_data('data/','activity_labels.txt')
#names(activities) <- names(c('actID','actDesc'))

col_names <- read_table('data/features.txt', 'colNames')
my_features <- separate(col_names, colNames ,c('colID','colDesc'), sep='\\ ')


#subjects_train <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/train/','subject_train.txt')
#subject_activity_train <-load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/train/', 'y_train.txt')
#data_train <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/train/', 'X_train.txt')
#subjects_test <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/test/','subject_test.txt')
#subject_activity_ttest <-load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/test/', 'y_test.txt')
#data_test <- load_data('/Users/jeff/github/Getting-and-Cleaning-Data-in-R/data/test/', 'X_test.txt')
