## Header ####
## Who: Georgina Anna Wager ####
## Project: Big Data Project ####
## What: Dummy: Getting the data ####
## Last edited: 2021-04-02  ####

## Install Packages 
if(!require(rtweet))install.packages("rtweet")
if(!require(tidyverse))install.packages("tidyverse")
if(!require(httr))install.packages("httr")
if(!require(twitteR))install.packages("twitteR")

## Loading the packages
library(rtweet)
library(httr)
library(tidyverse)
library(twitteR)
library("openssl")
library("httpuv")

## App name from api set-up 
appname <- "app_name"

## Now obtain the Consumer API key and the Consumer API secret key from the Keys
## and Tokens tab on the Twitter development dashboard.

consumer_key <- "your_consumer_key"
consumer_secret <- "your_consumer_secret"
access_token <- "your_access_token"
access_secret <- "your_access_secret"

## Create token named "twitter_token"
twitter_token <- create_token(
  app = "app_name",
  consumer_key = "your_consumer_key",
  consumer_secret = "your_consumer_secret",
  access_token = "your_access_token",
  access_secret = "your_access_secret")

## Preparing to pull the data now we have access codes from twitter
setwd(filepathhere) ## setting your working directory

## Identifying the search words
terms <- c("vegan","vegans")

terms_search <- paste(terms, collapse = " OR ")## stating the search as "vegan" or "vegans" not both

# Capturing Twitter data 
rt <- rtweet::search_tweets(terms_search, n = 10000, lang="en", include_rts = FALSE) ## searching for all the 
## tweets that are in english, no retweets allowed, and searching for 10,000 tweets

## Turning the twitter data into a data frame 
data1 <- data.frame(rt) ## Ensuring that the data pulled is a data frame

data1 <- data1[c(3,7,11,12,78,79)] ## selecting only the text column, the display text width column, the favorite count, the retweet count, the followers count and the friends count

install.packages('writexl') ## installing the package to turn the data into an excel file
library(writexl) ## pull the library
write_xlsx(data1, 'twitterdata.xlsx') ## saving the data as twitter data in the working directory that was set earlier 

