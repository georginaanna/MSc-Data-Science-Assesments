### MRP Project

MRP Project for the my MSc Course: Data Science for Global Agriculture, Food and Environment ran by Dr Ed Harris at Harper Adams University College. 

#### Project Overview

This project will contain a Literature Review on The importance of accuracy and unbiased training data for supervised learning and a Journal Article on The impact of subject repeatability in bounding box placement for computer vision training data.

These will not be uploaded until after the project has been marked otherwise I would be plagiarising myself! 

#### Github Repository Information

Location: https://github.com/georginaanna/MSc-Project--Training-Data--.git

#### Structure

Each folder in the repeatability-master folder represents a subject. The folders that contain the word “live” contain subject labelling information for the live experiment and vice versa for “computer”. The “_pics” folder contains the ten unique plots that were labelled three times by each subject during computer labelling and three ties by each subject during live labelling. The labelling information from each subject 30 labelled images is contained in their unique folders as a txt file. Each txt file contains information on all labels for one image. 

To sort the data, set up your working directory to the repeatability-master folder and run the centre-data.R script. This creates a data table and computes the number of bounding boxes per image and the distance between centres. To repeat the statistically analyse that was carried out in the Journal Article run the statisticalanalysis.R script. 





