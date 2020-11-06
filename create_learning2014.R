#IODS Exercise 2 data wrangling/creation script. Perttu Kajatkari, 4.11.2020

#Load the dplyr library (needed for select).
library(dplyr)

#Read the dataset into memory
full_dataset <- read.table("./data/JYTOPKYS3-data.txt", header=TRUE, sep="\t")

#Check the dimensions of the data
dim(full_dataset)

#check the structure of the data
str(full_dataset)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#Select the the first requested (unchanged) variables to initialize the analysis dataset
analysis_dataset = select(full_dataset, "gender", "Age","Attitude","Points")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(full_dataset, one_of(deep_questions))
analysis_dataset$deep <- rowMeans(deep_columns)

#same for stategic questions
stra_columns <- select(full_dataset, one_of(strategic_questions))
analysis_dataset$stra <- rowMeans(stra_columns)

#ditto surface
surf_columns <- select(full_dataset, one_of(surface_questions))
analysis_dataset$surf <- rowMeans(surf_columns)

#exclude entries with zero points
analysis_dataset <- filter(analysis_dataset, Points > 0)

#check that the data is OK
str(analysis_dataset)
head(analysis_dataset)

#write the dataset to a file
write.table(analysis_dataset, file="./data/learning2014.txt")

#and test that the file is readable

learning2014 <- read.table("./data/learning2014.txt",header=TRUE)
str(learning2014)
