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

# select only columns with  mean and std values + Activity Code by using grep
SubXY<-XY[,grep("ActivityCode|std|mean",names(XY))]

# read subject data for test and train
subjTest<-read.table("test/subject_test.txt")
subjTrain<-read.table("train/subject_train.txt")

#merge two subject datasets for test and train 
Subjects<-rbind(subjTest,subjTrain)
# Create column name for subjects
names(Subjects)<-"Subjects"

# combine observation and activity code into a single frame
DataWithSubjects<-cbind(Subjects,SubXY)


# read activity labels so we can join it to observation data and have activity label spelled out
AL<-read.table("activity_labels.txt")

#merge activity labels with created data frame
mergedDataActivityLabels = merge(AL,DataWithSubjects,by.x="V1",by.y="ActivityCode",all=TRUE)
head(mergedDataActivityLabels)

names(mergedDataActivityLabels)[1]<-"Activitycode"
names(mergedDataActivityLabels)[2]<-"ActivityLabel"


# calculate mean values for all observations in our data grouped by Subjects and ActivityLabel
AGR<-aggregate(mergedDataActivityLabels[, 4:82], list(mergedDataActivityLabels$Subjects,mergedDataActivityLabels$ActivityLabel), mean)

# correct the names for the data frame adding - avg at the end of each observation label.

ModNames<-as.list('')
for (i in 3:81){
  ModNames[i]<-paste(names(AGR)[i],"-avg",sep="")  
  
}
ModNames[1]<-"Subjects"
ModNames[2]<-"ActivityLabel"

names(AGR)<-ModNames


# write data frame 
write.table(AGR,"AveragesBySubjectsAndActivity.txt")

