## Description of the outputed data (tidy_data.txt)

The [source data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) was analysed using the `run_analysis.R` file to produce a cleaned and tidied dataset, which has the average values for all the std and mean columns in the source data.


### Variables / Data
* 1. subject, integer id for the 30 participants 
* 2. activity, one of the following 
        - "WALKING"
        - "WALKING_UPSTAIRS"
        - "WALKING_DOWNSTAIRS"
        - "SITTING", "STANDING"
        - "LAYING"
* 3-88. the average values for all the std and mean values for the various measurements

### Transformations
1. The training and test data were combined
2. The subjects were merged into the data
3. The activity id was replaced with their string reperesentation
4. The data was tidied, (removing unnecessary columns) 
5. The data was summarized (mean) by subject and activity for each `std` and `mean` column


Please refer to the `features_info.txt` in the source data for more details on the columns