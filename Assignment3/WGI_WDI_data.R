#####################################
# Corruption and Accountability Mechanisms - 
# by Roberto Mart??nez B. Kukutschka and Mariam Sanjush
# Due date: 15.04.2016
#####################################
# 1. Set working directory for our two computers (so that the code runs on either of them)
getwd()
try(setwd("~/Documents/Assignment1/"), silent = TRUE)
  
# 2. Load libraries
library(httr)
library(plyr)
library(xlsx)
library(rio)
library(stargazer)
library(Zelig)
library(repmis)
library(plm)
library(tidyr)
library(countrycode)
library(dplyr)
library(Hmisc)
library(WDI)
library(xlsxjars)
library(rJava)
library(ggplot2)
library(zoo)
library(countrycode)

#####################################
# SECTION I: COLLLECTING DATA 
#####################################

#STEP 1: Download data for Dependent Variable: Corruption
#Given that out research question treats corruption as the dependent variable, we first need an indicator of
#the extent of corruption in a country. Given its availability and comparability across time, we decided to use
#the Control of Corruption estimate from the Worldwide Governance Indicators Database. Control of Corruption (CoC) 
#captures perceptions of the extent to which public power is exercised for private gain, including both petty and 
#grand forms of corruption, as well as "capture" of the state by elites and private interests.

# The first step is to obtain the data from the website:

try(URL <- "http://info.worldbank.org/governance/wgi/index.aspx?fileName=wgidataset.xlsx", silent = TRUE)
fname <- "worldbank_wgidataset.xlsx"
if (!(file.exists(fname))) {
  fname <- tempfile()
  download.file(URL, fname, mode='wb')
}
ccraw <- read.xlsx2(fname, 7, sheetName = NULL, startRow = 14, endRow = 230, colIndex = NULL, as.data.frame = TRUE, header = FALSE)

# We create a new data frame containing only the data we are interested in. The new object keeps only
# the control of corruption estimate.

cc <- ccraw[c(2, 1, 3, 9, 15, 21, 27, 33, 39, 45, 51, 57, 63, 69, 75, 81, 87, 93)]

# Set the years as an observation 
names(cc) = as.character(unlist(cc[1,]))
cc = cc[-1,]
row.names(cc) <- NULL
colnames(cc)[1] <- "wbcode"
colnames(cc)[2] <- "country"

# Ordering the data
cc <- gather(cc, Year, Estimate, 3:18)
cc <- cc[order(cc$country, cc$year), ]
row.names(cc) <- NULL

# Create ID for each observation and matching country codes
cc <- mutate(cc, ID = rownames(cc))
cc <- cc[c(5,1,2,3,4)]
cc$iso2c <- countrycode(cc$wbcode, origin = "wb",destination = "iso2c", warn = TRUE)
cc$country <- countrycode(cc$iso2c, origin = "iso2c",destination = "country.name", warn = TRUE)
cc <- cc[c(1,6,2,3,4,5)]
cc <- cc[-c(3)]
colnames(cc)[1] <- "id"
colnames(cc)[4] <- "year"
colnames(cc)[5] <- "estimate"

#STEP 2: Download data for independent variables
#Having downloaded the required data for our dependent variable, we proceed to download additional
#variables that will be necessary for our analysis from the World Development Indicators Database.

#TRADE: the sum of exports and imports of goods and services measured as a share of gross domestic product.
trade <- WDI(indicator = 'NE.TRD.GNFS.ZS', start= 1996, end = 2014)

#EDUCATION: Gross enrollment ratio is the ratio of total enrollment, regardless of age, to the population of the age group that officially corresponds to the level
#of education shown. Secondary education completes the provision of basic education that began at the primary level, and aims at laying the foundations 
#for lifelong learning and human development, by offering more subject- or skill-oriented instruction using more specialized teachers.
education <- WDI(indicator='SE.SEC.ENRR', start= 1996, end= 2014)

#COMPETITIVENESS: The data covering taxes payable by businesses, measure all taxes and contributions that are government mandated (at any level - federal,
#state, or local), apply to standardized businesses, and have an impact in their income statements. The taxes covered go beyond the definition of
#a tax for government national accounts (compulsory, unrequited payments to general government) and also measure any imposts that affect business accounts. 
#The main differences are in labor contributions and value added taxes. The data account for government-mandated contributions paid by the employer to a 
#requited private pension fund or workers insurance fund but exclude value added taxes because they do not affect the accounting profits of the business 
#- that is, they are not reflected in the income statement.
competitiveness <- WDI(indicator='IC.TAX.DURS', start=1996, end=2014)

#URBAN POPULATION: refers to people living in urban areas as defined by national statistical offices. It is calculated using World Bank
#population estimates and urban ratios from the United Nations World Urbanization Prospects.
urban <- WDI(indicator='SP.URB.TOTL.IN.ZS', start=1996, end=2014)

#GDP PER CAPITA (PPP): is gross domestic product converted to international dollars using purchasing power parity rates. An international dollar has 
#the same purchasing power over GDP as the U.S. dollar has in the United States. GDP is the sum of gross value added by all resident 
#producers in the economy plus any product taxes and minus any subsidies not included in the value of the products. It is calculated 
#without making deductions for depreciation of fabricated assets or for depletion and degradation of natural resources. Data are in 
#constant 2011 international dollars.
gdppc <- WDI(indicator = 'NY.GDP.MKTP.PP.KD', start= 1996, end = 2014)

# Aggregate all WDI downloaded indicators into a single data frame for easier merge with corruption data.
wdi <- merge(trade, gdppc,by=c("iso2c","year","country"), all = TRUE)
wdi <- merge(wdi, education,by=c("iso2c","year","country"), all = TRUE)
wdi <- merge(wdi, competitiveness,by=c("iso2c","year","country"), all = TRUE)
wdi <- merge(wdi, urban,by=c("iso2c","year","country"), all = TRUE)

# Inserting ISO2C codes to the WDI data in order to allow merge with corruption data.

wdi$country <- countrycode(wdi$iso2c, origin = "iso2c",destination = "country.name", warn = TRUE)

# STEP 3: Create and aggregated database
finaldata <- merge(wdi,cc,by=c("iso2c","year", "country"), all = TRUE)

# Rename variables for easier identification
finaldata <- rename  (finaldata,
                trade = NE.TRD.GNFS.ZS,
                education = SE.SEC.ENRR,
                competitiveness = IC.TAX.DURS,
                gdppc = NY.GDP.MKTP.PP.KD,
                urban = SP.URB.TOTL.IN.ZS,
                cocscore = estimate,
                country = country
                )

# Create a csv file with the final version of the data
write.csv(finaldata, file="WGI_WDI_data.csv")