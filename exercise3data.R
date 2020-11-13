#IODS Exercise 3 data wrangling/creation script.
#Perttu Kajatkari, 12.11.2020

#Load the dplyr library (needed for inner_join).
library(dplyr)

#Read the two datasets into memory
student_por <- read.csv("./data/student-por.csv",sep=";")
student_mat <- read.csv("./data/student-mat.csv",sep=";")

#Check the dimensions of the data
dim(student_por)
dim(student_mat)

#check the structure of the data
str(student_por)
str(student_mat)

#Combine the two data sets by using the condition that if the variables given in 
#the factor "join_by" are the same, the student is the same.
join_by <- c( "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
joined_students <- inner_join(student_por, student_mat, by=join_by)

#check the structure and dimensions of the joined data
str(joined_students)
dim(joined_students)

#remove the "duplicate" columns, i.e., replace the ?.x and ?.y columns with just ?
students <- select(joined_students, one_of(join_by))
other_columns <- colnames(student_por)[!colnames(student_por) %in% join_by]

#for loop shamelessly plundered from the datacamp course
for ( column_name in other_columns ){
  print(column_name)
  # select two columns from 'students' with the same original name
  two_columns <- select(joined_students, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    students[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    students[column_name] <- first_column
  }
}

str(students)
dim(students)

#find the "real" duplicates. The exercise instructions/email were quite vague about this,
#since there was no explicit criterion given what are actually considered to be duplicates.
#Because the 'join_by' factor is used to join the two dataframes, it is natural to
#assume, that the students with same entries in those columns are in-fact duplicates
dupes <- duplicated(students[,join_by])

#Use the result to select only unique students. 
#Decided not to do this, however, since the rest of the columns might
#contain data that requires, e.g., averaging etc.
#students <- students[!dupes,]

#check the structure and dimensions
#dim(students)
#str(students)

#create variable that contains the total average alcohol use
students <- mutate(students, alc_use = (Dalc+Walc)/2)
students <- mutate(students, high_use =  alc_use > 2)

#check the structure and dimensions
dim(students)
str(students)

#write the dataset to a file
write.table(students, file="./data/students_alc.txt")

#and test that the file is readable

testing <- read.table("./data/students_alc.txt",header=TRUE)
str(testing)
dim(testing)
