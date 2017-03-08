#Emma Haapa, 4.3.2017. This is a file in which the final data wrangling excercise is executed.

rm(list = ls())

# Reading the full Community and Crime data into R
CommunityCrime <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/00211/CommViolPredUnnormalizedData.txt", sep=",", na.strings = c("?"))

# The column names were given as a separate file, so I read it as a different data set.
data <- read.table("columnnames1.txt", sep=",")

# The data had another column that consisted of NA's; I didn't know what to do with it so I erased it.
names <- data[,-2]

# Assigning the names data as the column names for the dataset CommunityCrime
colnames(CommunityCrime) = names

# Seeing whether this worked out, and it seems that the column names were assigned correctly.
colnames(CommunityCrime)


# Summary of the CommunityCrime dataset
summary(CommunityCrime)

#Accessing libraries
library(gmodels) #accessed the gmodels-library
library(gdata) #accessed the gdata-library
library(dplyr) #accessed the dplyr-library
library(readr) #accessed the readr-library
library(tidyr) #accessed tidyr-library

# The CommunityCrime data has 2215 rows and 147 columns, i. e. 2215 observations and 147 variables.
dim(CommunityCrime)
# The structure of the data:
str(CommunityCrime)
# The str-function also states that there are 1994 observations and 128 variables in the data. The variables are coded as combinations of letters that refer to the aspect of the variable.
glimpse(CommunityCrime)

# Save the communityname and state columns as character vectors, as they were misinterpreted as factors
CommunityCrime$communityname <- as.character(CommunityCrime$communityname)
CommunityCrime$state <- as.character(CommunityCrime$state)
# Thinking about which columns to keep. Looking at the summary of the dataset
# I came to the conclusion that there was no interest in keeping columns with
# loads of missing values, i.e. I intend to remove the columns "community", "communityname",
# "PolicCars", "PctPolicWhite", "PctPolicBlack", "PctPolicHisp", "PctPolicAsian", 
# "PctPolicMinor", "LemasPctPolicOnPatr", "PolicOperBudg", "LemasGangUnitDeploy", 
# "PolicBudgPerPop", "PolicPerPop", "PolicReqPerOffic", "LemasTotalReq",
# "LemasTotReqPerPop", "LemasSwornFT", "LemasSwFTPerPop" and "LemasSwFTFieldOps".
# Also, as were planning to execute multiple linear regression on this dataset, 
# it would be nonsensical to keep the nominal variable "county" in the dataset.


exclude_columns <- c("county", "community", "communityCode", "countyCode", "PolicCars", "PctPolicWhite", "PctPolicBlack", "PctPolicHisp", "PctPolicAsian", "PctPolicMinor", "LemasPctPolicOnPatr", "PolicOperBudg", "LemasGangUnitDeploy", "PolicBudgPerPop", "PolicPerPop", "PolicReqPerOffic", "LemasTotalReq", "LemasTotReqPerPop", "LemasSwornFT", "LemasSwFTPerPop", "LemasSwFTFieldOps")

# Creating a new variable for the linear regression: total percent of homeless.

CommunityCrime["PctHomeless"] <- round((CommunityCrime["NumStreet"] + CommunityCrime["NumInShelters"]) / CommunityCrime["population"] * 100, digits = 2)


CommunityCrime11 <- dplyr::select(CommunityCrime, -one_of(exclude_columns))
dim(CommunityCrime11) # 2215 rows, 129 variables.

# Setting Community name and state as rownames and removing those variables from the data set.
rownames(CommunityCrime11) <- paste(CommunityCrime11$communityname, CommunityCrime11$state, sep = ",")
CommunityCrime11 <- CommunityCrime11[,-1]
CommunityCrime11 <- CommunityCrime11[,-1]

rownames(CommunityCrime11)
names(CommunityCrime11) 
# Checking whether this worked out - it did.


# Configure data further: keep only interesting columns "ViolentCrimesPerPop", "population", "PctForeignBorn", "PctHomeless", "NumKindsDrugsSeiz", "PopDens","perCapInc", "PolicPerPop", "PctLess9thGrade","PctRecentImmig","NumInShelters", "racepctblack", "PctEmploy", "MalePctNevMarr", "PctWorkMom", "PctPopUnderPov", "NumStreet", "medIncome" and "PctPersDenseHous".

keep_columns <- c("ViolentCrimesPerPop", "population", "PctForeignBorn","PctHomeless", "PopDens","perCapInc", "PctUsePubTrans", "PctLess9thGrade","PctRecentImmig","NumInShelters","PctUsePubTrans", "racepctblack", "PctEmploy", "MalePctNevMarr", "PctWorkMom", "PctPopUnderPov", "NumStreet", "medIncome", "PctPersDenseHous")

CommunityCrime22 <- dplyr::select(CommunityCrime11, one_of(keep_columns))
dim(CommunityCrime22) # 2215 observations, 18 variables.

# Omit missing values from the data

communityCrime221 <- na.omit(CommunityCrime22)
dim(communityCrime221) # 1994 observations, 18 variables.

# Write table and save the smaller data into working directory for working on linear regression.
write.table(communityCrime221, file = "CommunityCrime22.txt", sep = ",", col.names = TRUE, row.names = TRUE)

#Normalize the data:
CommunityCrime22_sn <- data.Normalization(communityCrime221,type="n4",normalization="column")

#Look at the summary:
summary(CommunityCrime22_sn) 

# Write table and save the data into working directory.
write.table(communityCrime221, file = "CommunityCrime221.txt", sep = ",", col.names = TRUE, row.names = TRUE)
