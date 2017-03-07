#Emma Haapa, 4.3.2017. This is a file in which the final data wrangling excercise is executed.

# Reading the full Community and Crime data into R
CommunityCrime <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/communities/communities.data", sep=",", na.strings = c("?"))
# The column names were given as a separate file, so I read it as a different data frame.
data <- read.table("columnnames.txt", sep=",")
# The data had another column that consisted of NA's; I didn't know what to do with it so I erased it.
names <- data[,-2]
# Assigned the names data as the column names for the dataset CommunityCrime
colnames(CommunityCrime) = names
# Seeing whether this worked out, and it seems that the column names were assigned correctly.
colnames(CommunityCrime)


# Summary of the CommunityCrime dataset
summary(CommunityCrime)

options(max.print=1000000) #maxprint, just in case

#Accessing libraries
library(gmodels) #accessed the gmodels-library
library(gdata) #accessed the gdata-library
library(dplyr) #accessed the dplyr-library
library(ggplot2) #accessed the ggplot2-library
library(readr) #accessed the readr-library
library(tidyr) #accessed tidyr-library

# The CommunityCrime data has 1994 rows and 128 columns, i. e. 1994 observations and 128 variables.
dim(CommunityCrime)
# The structure of the data:
str(CommunityCrime)
# The str-function also states that there are 1994 observations and 128 variables in the data. The variables are coded as combinations of letters that refer to the aspect of the variable.
glimpse(CommunityCrime)

# Omitting missing values from the dataset
na.omit(CommunityCrime)

# Save the communityname column as character, as it was misinterpreted as factor
CommunityCrime$communityname <- as.character(CommunityCrime$communityname)

# Thinking about which columns to keep. Looking at the summary of the dataset
# I came to the conclusion that there was no interest in keeping columns with
# loads of missing values, i.e. I intend to remove the columns "community", "communityname",
# "PolicCars", "PctPolicWhite", "PctPolicBlack", "PctPolicHisp", "PctPolicAsian", 
# "PctPolicMinor", "LemasPctPolicOnPatr", "PolicOperBudg", "LemasGangUnitDeploy", 
# "PolicBudgPerPop", "PolicPerPop", "PolicReqPerOffic", "LemasTotalReq",
# "LemasTotReqPerPop", "LemasSwornFT", "LemasSwFTPerPop" and "LemasSwFTFieldOps".
# Also, as were planning to execute multiple linear regression on this dataset, 
# it would be nonsensical to keep the nominal variable "county" in the dataset. 

exclude_columns <- c("county", "community", "PolicCars", "PctPolicWhite", "PctPolicBlack", "PctPolicHisp", "PctPolicAsian", "PctPolicMinor", "LemasPctPolicOnPatr", "PolicOperBudg", "LemasGangUnitDeploy", "PolicBudgPerPop", "PolicPerPop", "PolicReqPerOffic", "LemasTotalReq", "LemasTotReqPerPop", "LemasSwornFT", "LemasSwFTPerPop", "LemasSwFTFieldOps")

CommunityCrime1 <- dplyr::select(CommunityCrime, -one_of(exclude_columns))
dim(CommunityCrime1) # 1994 rows, 108 variables.
colnames(CommunityCrime1)
rownames(CommunityCrime1) <- paste(CommunityCrime1$state, CommunityCrime1$communityname)
CommunityCrime1 <- CommunityCrime1[,-1]
CommunityCrime1 <- CommunityCrime1[,-1]

colnames(CommunityCrime1)


# Write table and save the data into the working directory for furher possible use
write.table(CommunityCrime1, file = "CommunityCrime1.txt", sep = ",", col.names = TRUE, row.names = TRUE)
?write.table
# Configure data further: keep only interesting columns ViolentCrimesPerPop, state, racepctblack, 
# PctEmploy, MalePctNevMarr, PctWorkMom and NumStreet.

keep_columns <- c("ViolentCrimesPerPop", "state", "racepctblack", "PctEmploy", "MalePctNevMarr", "PctWorkMom", "PctIlleg", "NumInShelters", "PctPopUnderPov", "NumStreet")

CommunityCrime2 <- dplyr::select(CommunityCrime1, one_of(keep_columns))
dim(CommunityCrime2) # 1994 observations, 10 variables.

# Write table and save the smaller data into working directory for working on linear regression.
write.table(CommunityCrime2, file = "CommunityCrime2.txt", sep = ",", col.names = TRUE)


