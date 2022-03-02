## HEADER ####
## What: Statistical Analysis 
## Who: George 
## Last edited: 2021-08-08

## CONTENTS ####
## 00 Setup ####
## 01 Variation between methods for the number of stems ####
## 02 Repeatability between subjects for the number of stems labelled for computer labelling ####
## 03 Repeatability between subjects for the number of stems labelled for live labelling ####
## 04 Random effects for number of stems ####
## 05 Variation between methods for the distance between centres ####
## 06 Repeatability between subjects for centres for computer labelling ####
## 07 Repeatability between subjects for centres for live labelling ####
## 08 Random effects for distance between centres ####


## 00 Setup ####
tic() 
source('centre-data.R') # make data objects
toc()

# install.packages("car")
# loading libraries 
library(car)
library(glmmTMB) # generalised linear models
library(dbplyr) # data wrangling
library(ggplot2) # data visulisations 
library(lme4) # fitting linear models
library(lmerTest) 
library(tictoc)
library(rptR) # one way to do repeatability

# creating new data frames 
stems_comp <- stems[stems$method == 'computer', ] # creating the data frame with only stems compter info
centres_comp <- c_dist[c_dist$method == 'computer', ] # creating the data frame with only centre compter info
stems_live <- stems[stems$method == 'live', ] #  # creating the data frame with only stems live info
centres_live <- c_dist[c_dist$method == 'live', ]  # creating the data frame with only centre compter info

# renaming
stems_comp$subject[stems_comp$subject == "butler"] <- "A"
stems_comp$subject[stems_comp$subject == "wager"] <- "B"
stems_comp$subject[stems_comp$subject == "harris"] <- "C"
stems_comp$subject[stems_comp$subject == "mhango"] <- "D"
stems_comp$subject[stems_comp$subject == "effie"] <- "E"
stems_comp$subject[stems_comp$subject == "lee"] <- "F"
stems_comp$subject[stems_comp$subject == "neil"] <- "G"
stems_comp$subject[stems_comp$subject == "potter"] <- "H"
stems_comp$subject[stems_comp$subject == "person1"] <- "I"
stems_comp$subject[stems_comp$subject == "person2"] <- "J"

centres_comp$subject[centres_comp$subject == "butler"] <- "A"
centres_comp$subject[centres_comp$subject == "wager"] <- "B"
centres_comp$subject[centres_comp$subject == "harris"] <- "C"
centres_comp$subject[centres_comp$subject == "mhango"] <- "D"
centres_comp$subject[centres_comp$subject == "effie"] <- "E"
centres_comp$subject[centres_comp$subject == "lee"] <- "F"
centres_comp$subject[centres_comp$subject == "neil"] <- "G"
centres_comp$subject[centres_comp$subject == "potter"] <- "H"
centres_comp$subject[centres_comp$subject == "person1"] <- "I"
centres_comp$subject[centres_comp$subject == "person2"] <- "J"

stems_live$subject[stems_live$subject == "butler"] <- "A"
stems_live$subject[stems_live$subject == "wager"] <- "B"
stems_live$subject[stems_live$subject == "harris"] <- "C"

centres_live$subject[centres_live$subject == "butler"] <- "A"
centres_live$subject[centres_live$subject == "wager"] <- "B"
centres_live$subject[centres_live$subject == "harris"] <- "C"

## 01 Variation between methods for the number of stems ####
model_1 <- lm(num_stems ~ method + (1| plot), data = stems)
summary(model_1)
anova(model_1)

## graphic
stems$method[stems$method == "computer"] <- "Computer"
stems$method[stems$method == "live"] <- "Live"

theme_set(theme_bw()) 
plot22 <- stems %>% 
  ggplot(aes(y=num_stems, x=method, fill = method, colour = method)) +
  geom_boxplot(size=0.9, alpha=0.9) +
  #scale_y_continuous(breaks = seq(from = 0, to = 20)) +# by = 1
  scale_y_continuous(expand = c(0,0),
                     limits = c(0,20), 
                     breaks = c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)) +
  scale_fill_manual(name= "method", values = c("grey60", "lightgrey")) +
  scale_color_manual(name = "method", values = c("red", "red")) +
  geom_jitter(color="black", size=0.9, alpha=0.9) +
  theme(legend.position = "none")

plot22


mynamestheme <- theme(axis.title = element_text(size = (26), colour = "black"),
                      axis.text = element_text(colour = "black", size = (22)),
                      panel.grid.major = element_line(colour="lightgrey", size = (0.5)),
                      panel.grid.minor = element_line(size = (0.2), colour="white"),
                      strip.text.x = element_text(size = 22),
                      plot.margin=unit(c(1,1,1,1),"cm"))

print(plot22 + mynamestheme + labs(y="Number of Meristems Identified\n", x = "\nMethod"))

## 02 Repeatability between subjects for the number of stems labelled for computer labelling ####
m0_stems <- rpt(num_stems ~ plot + (1 | subject), 
                data = stems_comp,
                datatype = "Gaussian",
                grname = c("subject"), 
                npermut = 0,
                nboot = 1000)
print(m0_stems)
summary(m0_stems)
# repeatability between subjects for computer labelling 0.613 

## 03 Repeatability between subjects for the number of stems labelled for live labelling ####
m1_stems <- rpt(num_stems ~ plot + (1 | subject), 
                data = stems_live,
                datatype = "Gaussian",
                grname = c("subject"), 
                npermut = 0,
                nboot = 1000)
print(m1_stems)
summary(m1_stems)
## repeatability between subjects for live labelling 0.292 

## 04 Random effects for number of stems ####
# random effects model for the effect of subjects on number of stems identified for computer experiment
model3 <- glmmTMB(num_stems ~ plot + (1 | subject), # plot as fixed effect and subject as random effect
                  data = stems_comp, # data used
                  family = gaussian) # data distribution 
summary(model3) # model summary 

rr <- glmmTMB::ranef(model3, condVar = TRUE) # extracting the conditional modes from the model
dd <- as.data.frame(x = rr) # creating a data frame 

# random effects model for the effect of subjects on number of stems identified for live experiment
model5 <- glmmTMB(num_stems ~ plot + (1 | subject), # plot as fixed effect and subject as random effect
                  data = stems_live, # data used 
                  family = gaussian) # data distribution 
summary(model5) # model summary 
print(model5)
parameters::standard_error(model5, effects = "random")
coef(model5)

ss <- glmmTMB::ranef(model5, condVar = TRUE)  # extracting the conditional modes from the model
ee <- as.data.frame(x = ss)  # creating a data frame 

## Creating a whole data frame to compare the random effects of computer and live for distance between centres
Method <- c("Computer")
dd <- data.frame(dd, Method)
Method <- c("Live")
ee <- data.frame(ee, Method)
new1 <- rbind(dd,ee)

theme_set(theme_bw()) # setting the theme 

# creating a plot 
plot7 <- new1 %>% 
  dplyr::filter(grpvar %in% "subject") %>%
  ggplot(aes(y=grp, x=condval)) +
  facet_wrap(~Method) +
  geom_point(size=4) +
  geom_errorbarh(aes(xmin = condval - 2*condsd,
                     xmax = condval + 2*condsd),
                 height=0.25, size = 1.5) +
  geom_vline(xintercept = 0, linetype =2, colour="red", size = 1.5)

plot7 ## random effects for subjects for computer labelling

mynamestheme <- theme(axis.title = element_text(size = (26), colour = "black"),
                      axis.text = element_text(colour = "black", size = (22)),
                      panel.grid.major = element_line(colour="lightgrey", size = (0.5)),
                      panel.grid.minor = element_line(size = (0.2), colour="white"),
                      strip.text.x = element_text(size = 22))

print(plot7 + mynamestheme + labs(y="Subject\n", x = "\nPredicted Random Effects ± 2 * Conditional Standard Deviation"))

## 05 Variation between methods for the distance between centres ####
model0 = lmer(distance ~ method + subject + (1 | plot), data = c_dist)
summary(model0)
anova(model0)

## graphic

c_dist$method[c_dist$method == "computer"] <- "Computer"
c_dist$method[c_dist$method == "live"] <- "Live"

theme_set(theme_bw()) 
plot24 <- c_dist %>% 
  ggplot(aes(y=distance, x=method, fill = method, colour = method)) +
  geom_boxplot(size=0.9, alpha=0.9) +
  #scale_y_continuous(breaks = seq(from = 0, to = 20)) +# by = 1
  scale_y_continuous(expand = c(0,0),
                     limits = c(0.00,0.026), 
                     breaks = c(0, 0.002, 0.004, 0.006, 0.008,0.01, 0.012,0.014, 0.016,0.018,0.02, 0.022,
                                0.024, 0.026)) +
  scale_fill_manual(name= "method", values = c("grey60", "lightgrey")) +
  scale_color_manual(name = "method", values = c("red", "red")) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme(legend.position = "none") +
  
  plot24


mynamestheme <- theme(axis.title = element_text(size = (26), colour = "black"),
                      axis.text = element_text(colour = "black", size = (22)),
                      panel.grid.major = element_line(colour="lightgrey", size = (0.5)),
                      panel.grid.minor = element_line(size = (0.2), colour="white"),
                      strip.text.x = element_text(size = 22),
                      plot.margin=unit(c(1,1,1,1),"cm"))

print(plot24 + mynamestheme + labs(y="Distance Between Centres\n", x = "\nMethod"))





## 06 Repeatability between subjects for centres for computer labelling ####
m0_centres <- rpt(distance ~ plot + (1 | subject), 
                  data = centres_comp,
                  datatype = "Gaussian",
                  grname = c("subject"), 
                  npermut = 0,
                  nboot = 1000)
print(m0_centres)
summary(m0_centres)

# repeatability between subjects for computer labelling 0.613 

## 07 Repeatability between subjects for centres for live labelling ####
m1_centres <- rpt(distance ~ plot + (1 | subject), 
                  data = centres_live,
                  datatype = "Gaussian",
                  grname = c("subject"), 
                  npermut = 0,
                  nboot = 1000)
print(m1_centres)
summary(m1_centres)

## repeatability between subjects for live labelling 0.00

## 08 Random effects for distance between centres ####
# random effects model for the effect of subjects on distance between centres for computer experiment
model33 <- glmmTMB(distance ~ plot + (1 | subject), # plot as fixed effect and subject as random effect 
                   data = centres_comp,# data used
                   family = gaussian) # data distribution
summary(model33) # model summary

aa <- glmmTMB::ranef(model33, condVar = TRUE) # extracting the conditional modes from the model
cc <- as.data.frame(x = aa) # creating a data frame 

# random effects model for the effect of subjects on distance between centres for live experiment
model55 <- glmmTMB(distance ~ plot + (1 | subject), # plot as fixed effect and subject as random effect 
                   data = centres_live,# data used
                   family = gaussian) # data distribution
summary(model55) # model summary

zz <- glmmTMB::ranef(model55, condVar = TRUE) # extracting the conditional modes from the model
ff <- as.data.frame(x = zz) # creating a data frame 

## Creating a whole data frame to compare the random effects of computer and live for distance between centres
#Method <- c("Computer")
cc <- data.frame(cc, Method)
#Method <- c("Live")
ff <- data.frame(ff, Method)
new <- rbind(cc,ff)

theme_set(theme_bw()) # setting the theme 

# creating a plot 
plot6 <- new %>% 
  dplyr::filter(grpvar %in% "subject") %>%
  ggplot(aes(y=grp, x=condval)) +
  facet_wrap(~Method) +
  geom_point(size=4) +
  geom_errorbarh(aes(xmin = condval - 2*condsd,
                     xmax = condval + 2*condsd),
                 height=0.25, size = 1.5) +
  geom_vline(xintercept = 0, linetype =2, colour="red", size = 1.5)

plot6 ## random effects for subjects for computer labelling

mynamestheme <- theme(axis.title = element_text(size = (26), colour = "black"),
                      axis.text = element_text(colour = "black", size = (22)),
                      panel.grid.major = element_line(colour="lightgrey", size = (0.5)),
                      panel.grid.minor = element_line(size = (0.2), colour="white"),
                      strip.text.x = element_text(size = 22))

print(plot6 + mynamestheme + labs(y="Subject\n", x = "\nPredicted Random Effects ± 2 * Conditional Standard Deviation"))
