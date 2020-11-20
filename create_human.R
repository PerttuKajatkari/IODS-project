#IODS Exercise 5 data wrangling/creation script. Perttu Kajatkari, 20.11.2020

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
hd <- setNames(hd, c('HDI_rank','country', 'HDI','life_exp','exp_edu','mean_edu','GNI','GNI-HDI'))
colnames(hd)
gii <- setNames(gii, c('GII_rank','country','GII','mortality','ado_birth_rate','parl_rep','edu2F','edu2M','labourF','labourM'))
colnames(gii)

#join the two datasets
human <- inner_join(hd, gii, by="country")
human$edu2R <- human$edu2F/human$edu2M
human$labourR <- human$labourF/human$labourM
#should be 195 obs of 19 variables!
str(human)
