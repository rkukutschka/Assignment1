################################

#INTRODUCTION TO COLLABORATIVE RESEARCH
#Assignment1: In-class assignment
#Descriptive Statistics using R databases
#29 February 2016
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

#I. OVERLOOK OF THE DATASET:
head(diamonds)
length(diamonds) 
nrow(diamonds) 
sapply(diamonds, is.numeric)
#The database contains 10 columns and 5390 rows
#The variables "cut", "color" and "clarity" are not numeric.

sapply(diamonds, function(x) sum(is.na(x)))
#There are no missing values in the dataset.

#II. DESCRIPTIVES FOR NUMERIC VARIABLES
sapply(diamonds[,c(1,5:10)], range) %>% round(digits=2) 
sapply(diamonds[,c(1,5:10)], mean) %>% round(digits=2) 
sapply(diamonds[,c(1,5:10)], median) %>% round(digits=2)
sapply(diamonds[,c(1,5:10)], sd) %>% round(digits=2)
#Based on the results the highest variation in the data seems to be in the variables "carat" and "price".
#The difference between the mean and the median values in these 2 variables also suggest a skewed data that is not normally distributed.

hist.default(diamonds$carat, breaks=10)
hist.default(diamonds$price, breaks=10)

hist.default(diamonds$table, breaks=30)
hist.default(diamonds$depth, breaks=30)

table(diamonds$color)
table(diamonds$clarity)
table(diamonds$color, diamonds$clarity)


#Type of data by object

summary(diamonds)


#Frequencies of categorical variables in the database (color, purity and cut)
table(diamonds$color)
table(diamonds$clarity)
table(diamonds$cut)
table(diamonds$color, diamonds$clarity)


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


#goodjob
