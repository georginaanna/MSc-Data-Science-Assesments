#### MSc-Data-Science-Assesments
Assessments that were submitted as part of the MSc Course: Data Science for Global Agriculture, Food and Environment Course at Harper Adams University by Georgina Anna Wager
The core data modules were C7084 Big Data and Decision Making - Case Studies, C7082 Techniques in Machine Learning and AI, C7081 Statistical Analysis for Data Science
and C7083 Data Visualisation and Analytics. 

This repro includes four folders representing a single core data module assesment and one folder for the 60 credit final year project. 
- `Big-Data-SparklyR` Big Data Project: Understanding the opinions surrounding veganism from tweets.
- `Data-Visulisation` Produce four visulisations for each of the three allocated data sets.
- `Deep-Learning-Computer-Vision` Classification of images that contain a lesion as either malignant or non malignant.
- `Statistical-Analysis` 
- `MRP Project` The importance of accuracy and unbiased training data for supervised learning

Contents of `Big-Data-SparklyR` 
- `Dummy Getting the data` r script that details how I obtained the data and pulled it to get a data set for reproducibility. By carrying out the code in this script 
you will not pull the exact data set used in this analysis.
- `twitterdata.csv` actual data that was used (minus any user information for privacy).
- `Big Data Project RMarkdown` code for analysisng the data
- `Project for C7084 Big Data and Decision Making - Case Studies` final report produced from the r markdown file

Contents of `Data-Visulisation` 
- `Australian Temperatures` r script for the Shiny App
- `bgraph.png` the bad visulisation for the critique section.
- `ggraph.png` good graph image
- `ggraph1.png` key for the good graph
- `Data Visualisation Portfolio and Critique` final report produced from the r markdown file
- `Data Visualisation Portfolio and Critique` pdf of final report

The data for the `Data-Visulisation` assesment was from three tidy tuesday data sets: Australian Fires Tidy Tuesday https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-01-07,
Global Crop Yields Tidy Tuesday https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-09-01 and San Fransico Trees Tidy Tuesday https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-01-28

Contents of `Deep-Learning-Computer-Vision`
- `CNN Model 1.pdf` Basic CNN, Image Size 150 x 150 and epoch at 30 (url: https://www.kaggle.com/georginawager/cnn-model-1)
- `CNN Model 2.pdf` CNN with augumentation, Image size 200 x 200 and epoch at 75 (url: https://www.kaggle.com/georginawager/cnn-model-2)
- `Final Model Results.png` Graph of the accuracy of the final model that is spoken about in the report
- `Report.pdf` final report in pdf format that has the final model, image size 120 x 120 and epoch at 75 also including an introduction, method, results, discussion and references (url https://www.kaggle.com/georginawager/final-report)
- `Video for Uploading Data into a Kaggle Kernal.mp4` Video on inputting the data into the kernal, youtube link is also here: https://www.youtube.com/watch?v=RU2pIzSftsg&t=16s

For the analysis, the data was not collected by myself, and instead was obtained from Kaggle, a website that contains many data sets for keen data science learners to enter competitions and practice predictive modelling and analytics 
(Shaikh, R, not dated).The location of the data set can be found here: https://www.kaggle.com/c/siim-isic-melanoma-classification/overview

Contents of `Statistical-Analysis`
- `EDA.R` Graphing the data 
- `Overall Analysis.R` Data anlysis 
- `Project 21112020.Rmd` R markdown of the final report 
- `Project-21112020.html` html file of final report
- `Project_ Socioeconomic factors that explain variation in exam scores.pdf` Final report
- `Student Performance.xlsx` Data 

Contents of `MRP Project` 

Project Overview
This project will contain a Literature Review on The importance of accuracy and unbiased training data for supervised learning and a Journal Article on The impact of subject repeatability in bounding box placement for computer vision training data.

Structure
Each folder in the repeatability-master folder represents a subject. The folders that contain the word “live” contain subject labelling information for the live experiment and vice versa for “computer”. The “_pics” folder contains the ten unique plots 
that were labelled three times by each subject during computer labelling and three ties by each subject during live labelling. The labelling information from each subject 30 labelled images is contained in their unique folders as a txt file. Each txt
file contains information on all labels for one image.

To sort the data, set up your working directory to the `repeatability-master` folder and run the `centre-data.R` script. This creates a data table and computes the number of bounding boxes per image and the distance between centres. To repeat the statistically
analyse that was carried out in the Journal Article run the `statisticalanalysis.R` script.
