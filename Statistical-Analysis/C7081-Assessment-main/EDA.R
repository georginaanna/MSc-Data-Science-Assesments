## HEADER ####
## Who: Georgina Anna Wager ####
## Project:Project: Socioeconomic factors that explain variation in exam scores. ####
## What: EDA ####
## Last edited: 2020-11-20 ####

## 1.0 Getting started ####
## 1.1 Installing Packages ####
## 1.2 Setting Working Directory ####
## 1.3 Examining variable types and changing accordingly ####
## 2.0 EDA ####

## 1.0 Getting started ####
## 1.1 Installing Packages ####
install.packages("ggplot2")
install.packages("dplyr")
install.packages("caTools")
install.packages("miscTools")
install.packages("psych")
install.packages("cluster")

## 1.2 Setting Working Directory
setwd("C:/Users/georg/Documents/GitHub/C7081-Assessment") ## Set the working directory to the location of the file
library(openxlsx) ## Tell R to load the openxlsx function from the library 
data <- read.xlsx("Student Performance.xlsx") ## Name the data set "data" and read the data 

## 1.3 Examining variable types and changing accordingly
names(data) ## List of the names of all the predictors within the data 
summary(data) ## Provide summary statistics on the data
str(data)

library(ggplot2)
library(dplyr)
library(caTools)
library(miscTools)

## Ensuring the variables are correct ####
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

## Viewing the data and the data variables
str(data)
head(data)

## 2.0 EDA ####
library(ggplot2) ##plotting the graphs for each score
plot <- ggplot(data, aes(math.exam.score)) + geom_histogram(binwidth=6, color="gray", aes(fill=gender))
plot <- plot + xlab("Math Scores") + ylab("Gender") + ggtitle("Math Scores by Gender")
plot

plot1 <- ggplot(data, aes(reading.exam.score)) + geom_histogram(binwidth=6, color="gray", aes(fill=gender))
plot1 <- plot1 + xlab("Reading Scores") + ylab("Gender") + ggtitle("Reading Scores by Gender")
plot1

plot2 <- ggplot(data, aes(writing.exam.score)) +  geom_histogram(binwidth=6, color="gray", aes(fill=gender))
plot2 <- plot2 + xlab("Writing Scores") + ylab("Gender") + ggtitle("Writing Scores by Gender")
plot2

## From looking at the maths score by gender plot, it is clear that male students have received better 
## scores in Math.However female  students have received better scores in reading and writing
## demonstrating that females are weaker in technical subjects, but stronger in the other ones.

## Looking at the data when the three numerical score measurements are combined. 

data <- data %>% mutate(total.score = math.exam.score + reading.exam.score + writing.exam.score)
data <- data %>% select(-math.exam.score, -reading.exam.score, -writing.exam.score)
## compiling the three dependent variables into one variable

## Looking at the distribution density of the total scores, shows that the total score is normally 
## distributed. 

ggplot(data, aes(x = total.score, fill = 'salmon1')) + geom_histogram(bins = 50, aes(y = ..density..)) + geom_density(alpha = 0.3) + theme_bw()

## Out of the 1000 students in this example,35.8% completed the exam preparation course,and the 
## remaining 64.2% did not.Students who completed the preparation class had better scores in all three exams. 

percent_of_students= round(prop.table(table(data$exam.preparation.course))* 100, digits = 1)
percent_of_studentspercent_of_students= round(prop.table(table(data$exam.preparation.course))* 100, digits = 1)
percent_of_students

graph1<-ggplot(data, aes(x = reorder(gender, total.score, FUN = median), y = total.score, col = gender)) + 
  geom_boxplot() + coord_flip() + theme_bw() ## gender 
graph1 <- graph1 + xlab("Gender") + ylab("Total Score") + ggtitle("Total Scores by Gender")
graph1

graph2<-ggplot(data, aes(x = reorder(lunch.price, total.score, FUN = median), y = total.score, col = lunch.price)) + 
  geom_boxplot() + coord_flip() + theme_bw() ## lunch
graph2 <- graph2 + xlab("Lunch Price") + ylab("Total Score") + ggtitle("Total Scores by students lunch options")
graph2

graph3<-ggplot(data, aes(x = reorder(parental.level.of.education, total.score, FUN = median), y = total.score, col = parental.level.of.education)) + 
  geom_boxplot() + coord_flip() + theme_bw() ## parental level of education
graph3 <- graph3 + xlab("Parental Level of Education") + ylab("Total Score") + ggtitle("Total Scores by students parental level of education")
graph3

graph4<-ggplot(data, aes(x = reorder(exam.preparation.course, total.score, FUN = median), y = total.score, col = exam.preparation.course)) + 
  geom_boxplot() + coord_flip() + theme_bw() ## exam prep
graph4 <- graph4 + xlab("Exam Preperation Course") + ylab("Total Score") + ggtitle("Total Scores by students participation in an exam preperation course")
graph4

boxplot.stats(data$hwy)$out ## checking for outliers in the data set 

## From the above graphs we can see that there could possible be a few outliers in the data set, 
## but when checking no outliers were identified in the data. There is also no missing values in the 
## data set. 