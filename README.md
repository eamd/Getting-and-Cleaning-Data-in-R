#run_analysis.R

__run_analysis.R__ is a single script that performs the following steps:

1. Combine the training and test data sets into a single data set.
2. Retrieve from the dataset, only those columns that contain the mean and standard deviation of the track variables.
3. Define meaningful names for all the columns. The column names are provided by a provided text file, named __features.txt__.
4. Define meaningful names for all the activity categories tracked. The text for the activities is found in a file named, **activity_labels.txt**.
5. Tidy up the resulting data calculating the mean for each variable (column) by activity within each subject.

The resulting object is dataframe_table named **msdf.summ**.

__NOTE__: The script assumes that the data is stored in a folder, __data__, located in the same directory that the script is located in. The __data__ folder contains the following files:

* features.txt
* activity_labels.txt
* test (a folder containing the test data)
* train (a folder containing the train data)