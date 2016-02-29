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
sapply(diamonds[,c(1,5:10)], mean) %>% round(digits=2) 
sapply(diamonds[,c(1,5:10)], sd) %>% round(digits=2)

table(diamonds$color)
table(diamonds$clarity)
table(diamonds$color, diamonds$clarity)

#Descriptives for categorical variables in the database (color, purity and cut)
#Mean of price of each categorical variable
by(diamonds$price,list(diamonds$clarity),FUN=mean) 
by(diamonds$price,list(diamonds$cut),FUN=mean) 
by(diamonds$price,list(diamonds$color),FUN=mean)

#Plotting diamonds by clarity
diamonds$clarity <- ordered(diamonds$clarity, 
      levels = c("I1", "SI1", "SI2", "VS1", "VS2", "VVS1", "VVS2", "IF")) #Ordering clarity of diamonds from worst to best
qplot(x = clarity, data = diamonds)

qplot(x = cut, data = diamonds)

#Boxplot of price of diamonds by cut
split(diamonds$price, diamonds$cut) %>% boxplot()
