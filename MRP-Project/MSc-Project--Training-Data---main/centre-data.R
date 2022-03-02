## HEADER ####
## What: Data Wrangling for Repeatability Data
## Who: Ed & George 
## Last edited: 2021-08-09 (George) 

## CONTENTS ####
## 00 Setup ####
## 01 Make data ####
## 02 Make Data: num_stems ####
## 03 Data: boxes & centres ####
## 04 Data: centres ####


## 00 Setup ####
## set working directory to the repeatability-master folder

## 01 Make data ####

# make vars
nplots <- 10
ncomp_subj <- 10
nlive_subj <- 3
nfiles_per_subject <- 30
nreps <- 3

subjects <- c('butler', 'effie', 'harris', 'lee', 'mhango', 
              'neil', 'person1', 'person2', 'potter', 'wager', 
              'butler', 'harris', 'wager')
methods_subjects <- c('computer', 'computer', 'computer', 'computer', 'computer', 
                      'computer', 'computer', 'computer', 'computer', 'computer', 
                      'live', 'live', 'live') 
groups <- c('HAU', 'BHive', 'HAU', 'BHive', 'HAU', 
            'BHive', 'India', 'India', 'BHive', 'HAU', 
            'HAU', 'HAU', 'HAU')
methods <- c('computer', 'live')
rep_id <- c('a', 'b', 'c')

# Get the txt file names and make category vars
files <- list.files(patter = "*.txt", recursive = TRUE) 

# see data-explainer.docx for explanation
plot <- c(rep(rep(1:10, 3), ncomp_subj),        # computer
          rep(rep(1:10, each = 3), nlive_subj)) # live
subject <- rep(subjects, each = nfiles_per_subject)
group <- rep(groups, each = nfiles_per_subject)
method <- c(rep(methods[1], ncomp_subj*nfiles_per_subject),
            rep(methods[2], nlive_subj*nfiles_per_subject))
pic_rep <- c(rep(rep(rep_id, each = ncomp_subj), nplots),
             rep(rep(rep_id, nlive_subj), nplots))

## 02 Make Data: num_stems ####
# num_stems
num_stems <- numeric()
for(i in 1:length(files)){
  num_stems[i] <- nrow(read.delim(file = files[i], 
                                  header = F, sep = " "))
}

stems <- data.frame(group, subject, method, num_stems, pic_rep, plot)

## 03 Data: boxes & centres ####
# read in all the box data
boxes <- data.frame()
for(i in 1:length(files)){
  boxes <- rbind(boxes, read.delim(file = files[i], 
                                   header = F, sep = " "))
}

# create features for all the box data
box_vars <- data.frame()
for(i in 1:length(num_stems)){
  box_vars <- rbind(box_vars, lapply(stems[i,], rep, num_stems[i]))
}

# combine df for all the box data and make better names
boxes <- cbind(boxes[,2:5], box_vars)
names(boxes) <- c("x_cent", "y_cent", "bb_width", "bb_height", "group",
                  "subject", "method" ,"num_stems", "pic_rep" , "plot" )

## 04 Data: centres ####

# centres distance within observers

# Pseudocode
# 0 boxes data
# 1 select subject and method
# 2 for each plot, cycle through each box like pic_rep 'a' and compare to b and c
# 3 find if a "close box" exists in each other pic
# 4 if so, compute dist of centre for a to b, a to c, b to c
# 5 store each dist by plot, subject and method


dist_dist <- numeric()
dist_subject <- character()
dist_method <- character()
dist_plot <- numeric()
dist_compare <- character()
dist_group <- character()

# this set of loops calculates all the distances

for(i in 1:length(subjects)){   # index for subjects and methods_subjects
  for(j in 1:nplots){           # index for plots
     
      temp_a <- boxes[boxes$subject == subjects[i]  & 
                      boxes$method == methods_subjects[i] &
                      boxes$plot == j &
                      boxes$pic_rep == 'a',  ]
      temp_b <- boxes[boxes$subject == subjects[i]  & 
                        boxes$method == methods_subjects[i] &
                        boxes$plot == j &
                        boxes$pic_rep == 'b',  ]      
      temp_c <- boxes[boxes$subject == subjects[i]  & 
                        boxes$method == methods_subjects[i] &
                        boxes$plot == j &
                        boxes$pic_rep == 'c',  ]
# a to b      
      for(k in 1:nrow(temp_a)){
        for(l in 1:nrow(temp_b)){
          dist_dist <- rbind(dist_dist, sqrt((temp_a$x_cent[k] - temp_b$x_cent[l])^2 +
            (temp_a$y_cent[k] - temp_b$y_cent[l])^2))
          dist_subject <- rbind(dist_subject, subjects[i])
          dist_method <- rbind(dist_method, methods_subjects[i])
          dist_plot <- rbind(dist_plot, j)
          dist_compare <- rbind(dist_compare, 'a-b')
          dist_group <- rbind(dist_group, temp_a$group[i])
          
        }
      }

# a to c      
      for(k in 1:nrow(temp_a)){
        for(l in 1:nrow(temp_c)){
          dist_dist <- rbind(dist_dist, sqrt((temp_a$x_cent[k] - temp_c$x_cent[l])^2 +
                                               (temp_a$y_cent[k] - temp_c$y_cent[l])^2))
          dist_subject <- rbind(dist_subject, subjects[i])
          dist_method <- rbind(dist_method, methods_subjects[i])
          dist_plot <- rbind(dist_plot, j)
          dist_compare <- rbind(dist_compare, 'a-c')
          dist_group <- rbind(dist_group, temp_a$group[i])
          
          
        }
      }

# b to c      
      for(k in 1:nrow(temp_b)){
        for(l in 1:nrow(temp_c)){
          dist_dist <- rbind(dist_dist, sqrt((temp_b$x_cent[k] - temp_c$x_cent[l])^2 +
                                               (temp_b$y_cent[k] - temp_c$y_cent[l])^2))
          dist_subject <- rbind(dist_subject, subjects[i])
          dist_method <- rbind(dist_method, methods_subjects[i])
          dist_plot <- rbind(dist_plot, j)
          dist_compare <- rbind(dist_compare, 'a-c')
          dist_group <- rbind(dist_group, temp_a$group[i])
          
          
        }
      }
      
      
  }
}

## Parameter for similar enough to count
## really need to stress test this...
close <- 0.025

c_dist <- data.frame(dist_dist[dist_dist < close],
                     dist_subject[dist_dist < close],
                     dist_method[dist_dist < close],
                     dist_plot[dist_dist < close],
                     dist_compare[dist_dist < close],
                     dist_group[dist_dist < close])
names(c_dist) <- c('distance', 'subject', 'method', 'plot', 
                   'comparison', 'group')

# clean up
rm(box_vars, group, subject, method, num_stems, pic_rep)
rm(files, groups, methods, ncomp_subj, nfiles_per_subject, nlive_subj, 
   nplots, rep_id, rep_num, reps, nreps, subjects, plot, methods_subjects)
rm(dis_compare, dist_dist, dist_method, dist_plot, dist_subject, 
   dist_compare, dist_group, temp_a, temp_b, temp_c)
rm(close, i,j,k,l)


