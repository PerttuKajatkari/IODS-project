
library(dplyr)
library(tidyr)

#Read in the data
BPRS  <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",header=TRUE)
RATS  <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",header=TRUE)

#Check data structure and summaries
str(BPRS)
str(RATS)

summary(BPRS)
summary(RATS)

#Turn categorical variables into factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$Group <- factor(RATS$Group)
RATS$ID <- factor(RATS$ID)

#Turn wide data into long data
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,6)))

RATSL <-  RATS %>% gather(key = time, value = weight, -ID, -Group)
RATSL <-  RATSL %>% mutate(time = as.integer(substr(time,3,4)))

#Check what has changed
str(BPRSL)
str(RATSL)

#Test that the data can be saved and read
write.table(BPRSL,"./data/BPRSL.txt")
write.table(RATSL,"./data/RATSL.txt")

test_bprsl <- read.table("./data/BPRSL.txt")
test_rats <- read.table("./data/RATSL.txt")
