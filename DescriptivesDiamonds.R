################################

#INTRODUCTION TO COLLABORATIVE RESEARCH
#Assignment1: In-class assignment
#Descriptive Statistics using R databases
#23 February 2016
#Mariam Sanjuch & Roberto Mart??nez B. Kukutschka

################################

#Packages used for the exercise:
library(dplyr)
library(rio)
library(ggplot2)

#Checking out the available databases:
data()

#We chose the database called "diamonds", which includes information regarding 
#the prices and attributes of almost 54,000 diamonds. 
data(diamonds) 
names(diamonds)
?diamonds

#Taking a look at the data:
head(diamonds)
tails(diamonds)
class(diamonds)

length(diamonds) #database contains 10 columns
nrow(diamonds) #database contains 5390 rows

#Type of data by object
sapply(diamonds, is.numeric)
summary(diamonds)

#Calculating the mean of numeric variables
sapply(diamonds, mean) %>% round(digits=2)
sapply(diamonds, sd) %>% round(digits=2)

table(diamonds$color)
table(diamonds$clarity)
table(diamonds$color, diamonds$clarity)

#Descriptives for categorical variables in the database (color, purity and cut)
by(diamonds$price,list(diamonds$purity),FUN=mean) 
