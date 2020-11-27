#IODS Exercise 5 data wrangling/creation script. Perttu Kajatkari, 20.11.2020

library(dplyr)
library(tidyr)
library(stringr)
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#check the structures of the datasets

#human development
str(hd)
dim(hd)
summary(hd)

#gender inequality
str(gii)
dim(gii)
summary(gii)


#rename variables
colnames(gii)
hd <- setNames(hd, c('HDI_rank','country', 'HDI','life.exp','exp.edu','mean_edu','GNI','GNI-HDI'))
colnames(hd)
gii <- setNames(gii, c('GII_rank','country','GII','mat.mort','ado.birth','parl.rep','edu2F','edu2M','labourF','labourM'))
colnames(gii)

#join the two datasets
human <- inner_join(hd, gii, by="country")
human$edu2R <- human$edu2F/human$edu2M
human$labourR <- human$labourF/human$labourM
#should be 195 obs of 19 variables!
str(human)

human$GNI=str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

human <- select(human,c("country","edu2F","labourF", "exp.edu", "life.exp","GNI","mat.mort","ado.birth","parl.rep"))
str(human)
#human <- filter(human, TRUE)

#remove rows with NA
human <- human %>% drop_na()

#check the data for area removal
tail(human,10)
last <- nrow(human) - 7
human = human[1:last,]

rownames(human) <- human$country
human <- select(human, -country)

#check that all is as wanted
tail(human,10)
str(human)

#write the dataset to a file
write.table(human, file="./data/human.txt")

#and test that the file is readable
hunam <- read.table("./data/human.txt",header=TRUE)
str(hunam)

