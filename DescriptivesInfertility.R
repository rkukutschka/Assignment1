#####--------------------------------------#####
#INTRODUCTION TO COLLABORATIVE RESEARCH
#Assignment1: In-class assignment
#Descriptive Statistics using R databases
#29 February 2016
#Mariam Sanjuch & Roberto Martinez B. Kukutschka
------------------------------------------------

#Setting up the working-directory
getwd()            #check the current working directory

ProjectWD <-"/Users/mariamsanjush/Desktop/Assignment_1/Descriptive_Infertality_Data.R"

setwd(ProjectWD)   #Using this command to set the working directory everytime

getwd()            #Re-check the working directory
dir()

#Package used:
library(dplyr)
library(rio)
library(ggplot2)

#Database selection
data()             #Checking out the available databases
data(infert)       #We have decided to work on the "Infertile dataset", which is about the infertility after spontaneous and induced abortion.
                   #includes 248 variables and 8 observations.
names (infert)
?infert
  
#-------Exploring the Data-----------#
#Inspection of the raw data
head(infert)
tail(infert)
View(infert)

#Type of data object and it's dimensions
class(infert)   #Its a "data.frame"

#two ways to the numbers of rows
nrow(infert)       #Number of rows=248  
length(infert[ ,1]) 
#two ways to the numbers of columns
ncol(infert)      #Number of columns=8  
length(infert)

str (infert)      #Overview of the data

#Ploting and inspecting the data
plot(infert)
identify(infert)

#Summarising the data
xtabs(infert)
sapply(infert, is.numeric)   #The variable "education" is not numeric
summary(infert)

#Checking out the missing values
sapply(infert, function(x) sum(is.na(x)))   #No missing values

#.Descriptives for the Numeric Variables
sapply(infert[,c(2:8)], range) %>% round(digits=2) 
sapply(infert[,c(2:8)], mean) %>% round(digits=2) 
sapply(infert[,c(2:8)], median) %>% round(digits=2)
sapply(infert[,c(2:8)], sd) %>% round(digits=2)
#Based on the results the highest variation in the data seems to be in the variables "carat" and "price".
#The difference between the mean and the median values in these 2 variables also suggest a skewed data that is not normally distributed.


hist.default(infert$age, breaks=20)
hist.default(infert$induced, breaks=30)

hist.default(diamonds$table, breaks=30)
hist.default(diamonds$depth, breaks=30)

table(infert$age)
table(infert$induced)      #143 women with no induced abortion, 68 women with one induced abortion and 37 women with two or more induced abortion.
table(infert$spontaneous)  #141 women with no spontaneous abortion, 71 women with one spontaneous abortion and 36 women with two or more spontaneous abortion.
table(infert$induced, infert$spontaneous)
table(infert$induced, infert$education)      #With more level of education, induced abortion is lower
table(infert$spontaneous, infert$education)  #With more level of education, spontaneous abortion is lower

#Changing age from numeric to catagorical variable
infert$agecat1<-cut(infert$age, c(21,26,31,36,41))
table(infert$agecat1)
table(infert$spontaneous, infert$agecat1)

prop.table(infert$spontaneous, infert$agecat1)
infert$Pct <- infert$Total.Count 
sum(infert$Total.Count)
infert

infert$percent<- prop.table(infert$age)
df
table(infert$age)

table(infert$education)
table(infert$age, infert$education)


#Calculating the mean of numeric variables
mean(infert$age)   #Mean of age variable at the infertile dataset is 31.50403
mean(infert$education) ?
