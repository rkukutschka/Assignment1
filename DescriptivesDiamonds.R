################################
#INTRODUCTION TO COLLABORATIVE RESEARCH
#Assignment1: In-class assignment
#Descriptive Statistics using R databases
#29 February 2016
#Mariam Sanjuch & Roberto Martinez B. Kukutschka
################################

#Setting-up working-directory
getwd()            #check the current working directory
setwd("~/Documents/Assignment1/")  #Setting the working directory


#Packages used for the exercise:
library(dplyr)
library(rio)
library(ggplot2)

#We chose the database called "diamonds", which includes information regarding 
#the prices and attributes of almost 54,000 diamonds.
data(diamonds) 
names(diamonds)

#I. OVERLOOK OF THE DATASET
head(diamonds)
length(diamonds) 
nrow(diamonds) 
sapply(diamonds, is.numeric)
#The database contains 10 columns and 53940 rows.
#The variables "cut", "color" and "clarity" are not numeric.

sapply(diamonds, function(x) sum(is.na(x)))
#There are no missing values in the dataset.

#II. DESCRIPTIVES FOR NUMERIC VARIABLES

sapply(diamonds[,c(1,5:10)], range) %>% round(digits=2) 
sapply(diamonds[,c(1,5:10)], mean) %>% round(digits=2) 
sapply(diamonds[,c(1,5:10)], median) %>% round(digits=2)
sapply(diamonds[,c(1,5:10)], sd) %>% round(digits=2)
#Based on the fact that the mean and the median of "price" are vey far from each other, the variable seems to be skewed/not normally distributed.
#The small standard deviation in "carat", "depth" and "table" show that the values for these variables are closely grouped together.

hist.default(diamonds$price, breaks=30)
#The histogram proves that "price" is indeed skewed. There is a high number of diamonds under $5000, but also a wide range in prices that go up to >$15,000.

hist(diamonds$carat, breaks=50)
hist(diamonds$depth, breaks=30)
hist(diamonds$table, breaks=50)

#III. DESCRIBING THE CATEGORICAL VARIABLES
#Given that categorical variables cannot be described with the same methods as the numerical ones, this section
#offers a descriptive overview of "color", "clarity" and "cut".
#The first step to describe categorical data is to show the FREQUENCY of each category:

table(diamonds$color)
#The color of diamonds ranges from J (worst) to D (best). The database contains 6775 diamonds
#with the best color (12.6%) and 2808 diamonds with the worst one. 

table(diamonds$clarity)
#Similar as with the color, the clarity of diamonds is also ranked from I1 (worst), SI1, 
#SI2, VS1, VS2, VVS1, VVS2 to IF (best). Only 1790 diamonds (3.32% of the sample) present the best 
#level of clarity and 741 (1.4%) present the worst.

table(diamonds$cut)
#Almost 40% of diamonds in the dataset (21551) have the best quality cut.

#FURTHER DESCRIPTIVE ANALYSIS:
#Given that diamonds are a girl's best friends, we are interested in finding out, whether the best quality
#are also the most most expensive. In order to do so, we calculated the mean price of a diamond by cut, color, clarity and size.

by(diamonds$price,list(diamonds$clarity),FUN=mean) 
by(diamonds$price,list(diamonds$cut),FUN=mean) 
by(diamonds$price,list(diamonds$color),FUN=mean)

diamonds$caratcat<-cut(diamonds$carat, c(0,1,2,3,4,5)) #Created a categorical variable of "carat"
by(diamonds$price,list(diamonds$caratcat),FUN=mean)

#Plotting diamonds by clarity
diamonds$clarity <- ordered(diamonds$clarity, 
      levels = c("I1", "SI1", "SI2", "VS1", "VS2", "VVS1", "VVS2", "IF")) #Ordering clarity of diamonds from worst to best
qplot(x = clarity, data = diamonds)

qplot(x = cut, data = diamonds)

#Boxplot of price of diamonds by cut
split(diamonds$price, diamonds$cut) %>% boxplot()

#Plotting the diamonds by carat and price
ggplot2::ggplot(diamonds, aes(carat, price)) +
  geom_point(shape=1) + geom_smooth(method=lm) + theme_bw()

##since carat is left-skewed you might wanna take the log
ln.carat <- log(diamonds$carat)
hist(ln.carat)

# Plotting price and logged carat the distribution appears non-linear
ggplot2::ggplot(diamonds, aes(ln.carat, price)) +
  geom_point(shape=1) + geom_smooth() + theme_bw()

source("DescriptivesInfertility.R", local = FALSE, print.eval = TRUE, verbose = TRUE)
