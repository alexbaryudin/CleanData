
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 
Using its embedded accelerometer and gyroscope, captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The experiments have been video-recorded to label the data manually. 
The original obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 


Files in folder ‘UCI HAR Dataset’ that were used in this project:

	SUBJECT FILES
		test/subject_test.txt
		train/subject_train.txt
	ACTIVITY OBSERVATION FILES
		test/X_test.txt
		train/X_train.txt
	Activity FILES
		test/y_test.txt
		train/y_train.txt
	features.txt - Names of column variables in the dataTable
	activity_labels.txt - Links the class labels with their activity name.

Description of abbreviations of measurements

	leading t or f is based on time or frequency measurements.
	Body = related to body movement.
	Gravity = acceleration of gravity
	Acc = accelerometer measurement
	Gyro = gyroscopic measurements
	Jerk = sudden movement acceleration
	Mag = magnitude of movement
	mean and SD are calculated for each subject for each activity for each mean and SD measurements.
	The units given are g’s for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec for the corresponding jerks.



During processing of these two dataset the following actions were taken:
	1. Test and train datasets were merged
	2. The measurements on the mean and standard deviation for each measurement were extracted. 
	3. Descriptive activity names to name the activities in the data set were added
	4. Descriptive variable names were added. 
	5. After that, new dataset was created  with the average of each variable for each activity and each subject.




Below are the code with explanation on what was done:

Read and merge activity Observations (X.. files), activity(Y.. files)  and Column labels(features.txt)

	# set current working directory
	setwd("C:/R/CleanDataProject/UCIHARDataset")

	# read observation data for test and train data sets
	xTe<-read.table("test/X_test.txt")
	xTr<-read.table("train/X_train.txt")

	#merge two observation dataset
	X<-rbind(xTe,xTr)

	# read row labels
	yTe<-read.table("test/Y_test.txt")
	yTr<-read.table("train/Y_train.txt")

	#merge two dataset
	Y<-rbind(yTe,yTr)

	# read label names from file and attach to the observations file
	f<-read.table("features.txt")
	names(X)<-f$V2

	# Create label for ActiviyCode read from Y files
	names(Y)<-"ActivityCode"

	# combine observation data and activity code into a single frame
	XY<-cbind(Y,X)

Select only columns that contain mean and standard deviation values

	# select only columns with  mean and std values + Activity Code by using grep
	SubXY<-XY[,grep("ActivityCode|std|mean",names(XY))]


Read and merge Subject data 

	# read subject data for test and train
	subjTest<-read.table("test/subject_test.txt")
	subjTrain<-read.table("train/subject_train.txt")

	#merge two subject datasets for test and train 
	Subjects<-rbind(subjTest,subjTrain)
	# Create column name for subjects
	names(Subjects)<-"Subjects"

	# combine observation and activity code into a single frame
	DataWithSubjects<-cbind(Subjects,SubXY)

Add Activiy Labels based on Activity codes that are in data 

	# read activity labels so we can join it to observation data and have activity label spelled out
	AL<-read.table("activity_labels.txt")

	#merge activity labels with created data frame
	mergedDataActivityLabels = merge(AL,DataWithSubjects,by.x="V1",by.y="ActivityCode",all=TRUE)
	head(mergedDataActivityLabels)

	names(mergedDataActivityLabels)[1]<-"Activitycode"
	names(mergedDataActivityLabels)[2]<-"ActivityLabel"

Calculate mean values for obervations in the data , grouped by Subject and ActivityLabel

	AGR<-aggregate(mergedDataActivityLabels[, 4:82], list(mergedDataActivityLabels$Subjects,mergedDataActivityLabels$ActivityLabel), mean)

correct the names for the data frame adding - avg at the end of each observation label.

	ModNames<-as.list('')
	for (i in 3:81){
	  ModNames[i]<-paste(names(AGR)[i],"-avg",sep="")  

	}
	ModNames[1]<-"Subjects"
	ModNames[2]<-"ActivityLabel"

	names(AGR)<-ModNames

Write date out
	write.table(AGR,"AveragesBySubjectsAndActivity.txt")




New datasets contains columns shown below.

 1   Subjects	 
 2   ActivityLabel 	
 3   tBodyAcc-mean()-X-avg	 
 4   tBodyAcc-mean()-Y-avg 	
 5   tBodyAcc-mean()-Z-avg	 
 6   tBodyAcc-std()-X-avg 	
 7   tBodyAcc-std()-Y-avg 	
 8   tBodyAcc-std()-Z-avg 
 9   tGravityAcc-mean()-X-avg 	 
 10   tGravityAcc-mean()-Y-avg  
 11   tGravityAcc-mean()-Z-avg  
 12   tGravityAcc-std()-X-avg  
 13   tGravityAcc-std()-Y-avg  
 14   tGravityAcc-std()-Z-avg 	
 15   tBodyAccJerk-mean()-X-avg 	
 16   tBodyAccJerk-mean()-Y-avg 	
 17   tBodyAccJerk-mean()-Z-avg 	
 18   tBodyAccJerk-std()-X-avg 	
 19   tBodyAccJerk-std()-Y-avg 	
 20   tBodyAccJerk-std()-Z-avg 	
 21   tBodyGyro-mean()-X-avg 	
 22   tBodyGyro-mean()-Y-avg 	
 23   tBodyGyro-mean()-Z-avg 	
 24   tBodyGyro-std()-X-avg 	
 25   tBodyGyro-std()-Y-avg 	
 26   tBodyGyro-std()-Z-avg 	
 27   tBodyGyroJerk-mean()-X-avg	 
 28   tBodyGyroJerk-mean()-Y-avg 	
 29   tBodyGyroJerk-mean()-Z-avg 	
 30   tBodyGyroJerk-std()-X-avg 	
 31   tBodyGyroJerk-std()-Y-avg 	
 32   tBodyGyroJerk-std()-Z-avg 	
 33   tBodyAccMag-mean()-avg 	
 34   tBodyAccMag-std()-avg 	
 35   tGravityAccMag-mean()-avg 	
 36   tGravityAccMag-std()-avg 	
 37   tBodyAccJerkMag-mean()-avg	 
 38   tBodyAccJerkMag-std()-avg 	
 39   tBodyGyroMag-mean()-avg 	
 40   tBodyGyroMag-std()-avg 	
 41   tBodyGyroJerkMag-mean()-avg 
 42   tBodyGyroJerkMag-std()-avg 	
 43   fBodyAcc-mean()-X-avg 	
 44   fBodyAcc-mean()-Y-avg 	
 45   fBodyAcc-mean()-Z-avg 	
 46   fBodyAcc-std()-X-avg 	
 47   fBodyAcc-std()-Y-avg 	
 48   fBodyAcc-std()-Z-avg 	
 49   fBodyAcc-meanFreq()-X-avg 	
 50   fBodyAcc-meanFreq()-Y-avg 	
 51   fBodyAcc-meanFreq()-Z-avg 	
 52   fBodyAccJerk-mean()-X-avg 	
 53   fBodyAccJerk-mean()-Y-avg 	
 54   fBodyAccJerk-mean()-Z-avg 	
 55   fBodyAccJerk-std()-X-avg 	
 56   fBodyAccJerk-std()-Y-avg 	
 57   fBodyAccJerk-std()-Z-avg 	
 58   fBodyAccJerk-meanFreq()-X-avg     
 59   fBodyAccJerk-meanFreq()-Y-avg 	
 60   fBodyAccJerk-meanFreq()-Z-avg 	
 61   fBodyGyro-mean()-X-avg 	
 62   fBodyGyro-mean()-Y-avg 	
 63   fBodyGyro-mean()-Z-avg 	
 64   fBodyGyro-std()-X-avg 	
 65   fBodyGyro-std()-Y-avg 	
 66   fBodyGyro-std()-Z-avg 	
 67   fBodyGyro-meanFreq()-X-avg	 
 68   fBodyGyro-meanFreq()-Y-avg 	
 69   fBodyGyro-meanFreq()-Z-avg 	
 70   fBodyAccMag-mean()-avg 	
 71   fBodyAccMag-std()-avg 	
 72   fBodyAccMag-meanFreq()-avg	 
 73   fBodyBodyAccJerkMag-mean()-avg 	
 74   fBodyBodyAccJerkMag-std()-avg 	
 75   fBodyBodyAccJerkMag-meanFreq()-avg	 
 76   fBodyBodyGyroMag-mean()-avg 	
 77   fBodyBodyGyroMag-std()-avg 	
 78   fBodyBodyGyroMag-meanFreq()-avg 	
 79   fBodyBodyGyroJerkMag-mean()-avg 	
 80   fBodyBodyGyroJerkMag-std()-avg 	
 81   fBodyBodyGyroJerkMag-meanFreq()-avg 
