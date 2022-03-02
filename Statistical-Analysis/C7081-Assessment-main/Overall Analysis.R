## HEADER ####
## Who: Georgina Anna Wager ####
## Project: Socioeconomic factors that predict variation in exam scores####
## What: Overall Analysis ####
## Last edited: 2020-11-20  ####

## 1.0 First Initial Analysis Steps ####
## 1.1 Installing a set of packages ####
## 1.2 Setting the Working Directory ####
## 1.3 Ensuring the variables are the correct class ####
## 2.0 Carrying out principal component analysis ####
## 3.0 Building a linear regression model ####
## 4.0 Random Forest ####


## 1.0 First Initial Analysis Steps ####

## 1.1 Installing a set of packages ####
install.packages("ggplot2") ##data visualization
install.packages("dplyr") ## functions that are verbs etc "mutate"
install.packages("randomForest")
install.packages("caTools")
install.packages("miscTools")
install.packages("caret")
install.packages("shiny") ## for knitting this document together
install.packages("broom")
install.packages("TinyTeX")
install.packages("Rtools")
install.packages("knitr")
install.packages("rmarkdown")

## Loading the packages
library(ggplot2) 
library(dplyr)
library(randomForest)
library(caTools)
library(miscTools)
library(rmarkdown)
library(broom)
library(caret)
library(shiny)
library(broom)

## 1.2 Setting the Working Directory ####
setwd("C:/Users/georg/Documents/GitHub/C7081-Assessment") ## Set the working directory to the location of the file
library(openxlsx) ## Tell R to load the openxlsx function from the library 
data <- read.xlsx("Student Performance.xlsx") ## Name the data set "data" and read the data 
names(data) ## List of the names of all the predictors within the data 
summary(data) ## Provide summary statistics on the data
str(data) ## identifying the class of each variable 

## 1.3 Ensuring the variables are the correct class ####
## Gender into a factor
class(data$gender) # Character
data$gender <- factor(data$gender)
class(data$gender) # Factor

## Lunch into a factor
class(data$lunch.price) # Character
data$lunch.price <- factor(data$lunch.price)
class(data$lunch.price) # Factor

## Ethnicity into a factor
class(data$ethnicity) # Character
data$ethnicity <- factor(data$ethnicity)
class(data$ethnicity) # Factor

## parental.level.of.education into a factor
class(data$parental.level.of.education) # Character
data$parental.level.of.education <- factor(data$parental.level.of.education)
class(data$parental.level.of.education) # Factor

## exam.preparation.course into a factor
class(data$exam.preparation.course) # Character
data$exam.preparation.course <- factor(data$exam.preparation.course)
class(data$exam.preparation.course) # Factor

## 2.0 Carrying out principal component analysis ####
set.seed(1)
pairs(data[,6:8]) ## Plotting (highly correlated dependent variables)
cor(data[,6:8]) ## Plotting (highly correlated dependent variables)

pr.out=prcomp(data[6:8],scale=TRUE) ## [6:8] here we are saying we want PCA Analysis on the three variables coloumn 6, 7 and 8
names(pr.out) ## information within the PCA

pr.out$center ## mean of the variables that were used for scaling prior to implementing PCA
pr.out$scale ## standard deviation of the variables that were used for scaling prior to implementing PCA

screeplot(pr.out) ## showing the variance of each principal component 
pr.out$x ## Printing out the principal component score vector for each row
biplot(pr.out) ## biplot of the PCA
plot(pr.out$x) ## plot of the PCA
names(pr.out) ## names of the PCA
pr.out$rotation ## the correlation between PC1 and each dependent variable
summary(pr.out) ## summary of the PCA

## PC1 is one variable and in this instance it is the new dependent variable for future linear regression models 
## ideally PC1 should be greater than 70% and in this case it is above 90% therefore this means that 
## 90% of the data is in PC1
## PC1 describes the variance shared between the three dependent variables

PC1<-pr.out$x[,"PC1"] ## Labeling the PC1 as a variable
data$PC1<-PC1 ## adding PC1 to our data set

## 3.0 Building a linear regression model ####

##splitting the data set into train and test 
set.seed(1)
data1 = sort(sample(nrow(data), nrow(data)*.8)) ## Splitting the datasets
train<-data[data1,] ## the training data set
test<-data[-data1,] ## the test data set 

## Model one
set.seed(1)
lm.fit1=lm(PC1~gender+ethnicity+parental.level.of.education+lunch.price+exam.preparation.course, data=train)
summary(lm.fit1)

## Model two
set.seed(1)
lm.fit2=lm(PC1~gender+ethnicity+parental.level.of.education+lunch.price, data=train)
summary(lm.fit2)

anova(lm.fit1,lm.fit2) ## anova of both models

## Prediction from the best fitted model 
set.seed(1) ## set the seed for reproducability
anova(lm.fit1) ## anova 
plot(lm.fit1) ## this model fits ok with the data set

set.seed(1)
y_pred1 <- predict(lm.fit1, newdata = test)
set.seed(1)
summary(lm.fit1)$r.squared # here we have an rsquared value of 23% this shows that the model explains 23% of the variance of y
set.seed(1)
mse.lin <- mean((test$PC1 - y_pred1)^2)
mse.lin ## the MSE 

## 4.0 Random Forest ####
## For the below analysis the original dependent variables have been combined to produce a total score and this total
## score has been converted to a numeric catergorical variable. 
set.seed(1)
data <- data %>% mutate(total.score = math.exam.score + reading.exam.score + writing.exam.score)
data <- data %>% select(-math.exam.score, -reading.exam.score, -writing.exam.score)

## Categorize data by range of values
set.seed(1)
data$Category[data$total.score < 50] = "E"
data$Category[data$total.score >= 50 & data$total.score < 100] = "D"
data$Category[data$total.score >= 100 & data$total.score < 150] = "C"
data$Category[data$total.score >= 150 & data$total.score < 200] = "B"
data$Category[data$total.score >= 200 & data$total.score < 250] = "A"
data$Category[data$total.score >= 250] = "A*"
data
set.seed(1)
class(data$Category) # Character
data$Category<-as.factor(data$Category)
class(data$Category) # Factor

class(data$Category) # Factor
data$Category<-as.numeric(data$Category)
class(data$Category) # Numeric

str(data) ## confirming that the Category variable is numeric
data$Category ## shows a list of where this fits into the data 

data1 = sort(sample(nrow(data), nrow(data)*.8)) ## Splitting the datasets
train1<-data[data1,] ## the training data set
test1<-data[-data1,] ## the test data set 

## 4.1 Random Forest ####
library(psych)
library(cluster)
library(fpc)
library(randomForest)

set.seed(1)
rf.data= randomForest(Category~.-total.score-PC1,data=train1,
                      mtry=5, importance =TRUE)
rf.data ## values for variance explained and the mean of squared residuals 
summary(rf.data)
set.seed(1)
yhat.rf = predict(rf.data ,data=test1)
set.seed(1)
mean((yhat.rf)^2) ## MSE

set.seed(1)
rf.data1= randomForest(Category~.-total.score-PC1,data=train1,
                       mtry=2, importance =TRUE)
rf.data1 ## value for % variance explained and the mean of squared residuals
summary(rf.data1)
set.seed(1)
yhat.rf = predict(rf.data1 ,data=test1)
set.seed(1)
mean((yhat.rf)^2) ## MSE

importance(rf.data1) ## Using the importance() function, we can view the importance of each variable.
## this rises a negative variable importance for parental level of education
varImpPlot(rf.data1)