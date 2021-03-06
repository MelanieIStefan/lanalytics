## items_change.R
## using data from two successive offerings of the course
## plots and quantifies how items have changed from one year to the next
## Written by MI Stefan

library(RColorBrewer) # allows us to use Cynthia Brewer's color schemes
library(ggplot2)    # extra plotting capabilities
library(xlsx)

dir.create("./items_change")

compare_2013_2014_raw <- read.csv("2013_2014_compare/time_level_easiness_2013_2014.csv")

## get rid of all first questions in 2013 (time readout not trustworthy)
compare_2013_2014 <- compare_2013_2014_raw[compare_2013_2014_raw[,'question_13']!=1,]

## plot the "star of change" for all questions
## prediction: if nothing happens, star should be the same in all directions
## if there is improvement, star should go towards the top left (?)

## General plots first

for (i in 1:nrow(compare_2013_2014)){
  easiness_change = compare_2013_2014[i,"easiness_14"]-compare_2013_2014[i,"easiness_13"]
  time_change = compare_2013_2014[i,"time_14"]-compare_2013_2014[i,"time_13"]
  compare_2013_2014[i,"easiness_change"] <- easiness_change
  compare_2013_2014[i,"time_change"] <- time_change
#  segments(0, 0, time_change, easiness_change)
}

# plot all
png("items_change/change_all_items.png")
plot(NA, xlim=c(-5,5), ylim=c(-0.5,0.5),xlab="time change", ylab="easiness change", 
     main="Item changes 2013-2014")
with(compare_2013_2014, mapply("segments", 0, 0, time_change, easiness_change))
dev.off()

# plot by question category


png("items_change/change_by_level.png")

cols <-  brewer.pal(3,"Dark2") 
title="Item changes 2013-2014"
plot <- ggplot() +
  facet_wrap(~level_14) +
  geom_segment(data=compare_2013_2014[complete.cases(compare_2013_2014[,"level_14"]),], 
               mapping=aes(x=0, y=0, xend=time_change, yend=easiness_change,col=level_14))+
  ggtitle(title) +
  scale_color_brewer(palette="Dark2", name="category") +  
  xlab("time change [min]") + 
  ylab("easiness change")  +
  theme(plot.title = element_text(size=20, face="bold", vjust=2)) +
  xlim(c(-5,5)) +
  ylim(c(-0.5,0.5)) 
  
print(plot)
dev.off()

## Plots by change and nature of change

## read in insrtructor file with question changes
itemsChange <- read.xlsx("Comparison_of_cognitive_level_2013-2014.xlsx",1)

# for all entries in our compare dataframe, read corresponding entry from itemsChange,
# add columns related to change

for (i in 1:nrow(compare_2013_2014)) {
  quiz = compare_2013_2014[i,"quiz_13"]
  question = compare_2013_2014[i,"question_13"]
  q_String = paste("2013_Quiz",quiz,"_q",question,sep="")  
  changes = itemsChange[grep(q_String,itemsChange$Question.ID.2013),11:23]

# classify changes
# since we are measuring MCQs only, not interested questoins that changed format
# or deleted questions
  
  changed_index = which(!is.na(changes))
#   
#   for (j in changed_index){
#     if (j == 6){
#       compare_2013_2014[i,'Edit']='Text'      
#     }
#     if (j %in% c(7,8)){
#       compare_2013_2014[i,'Edit']='Distractor'
#     }
#     if (j %in% c(9:11)){
#       compare_2013_2014[i,'Edit']='Major'
#     }
#     if (j==12){
#       compare_2013_2014[i,'Edit']='None'
#     }
#   }
}
  
  
# just check how many of what changes are in the dataset - some edits may be counted twice
# Therefore totalEdits + nunberUnchanged will be >= total nmber of Questions

# numberTextEdits = length(which(compare_2013_2014[,'TextEdit']==1))
# numberDistractorEdits = length(which(compare_2013_2014[,'DistractorEdit']==1))
# numberMajorEdits = length(which(compare_2013_2014[,'MajorEdit']==1))
# 
# totalEdits = numberTextEdits + numberDistractorEdits + numberMajorEdits
#     
# numberUnchanged = length(which(compare_2013_2014[,'Unchanged']==1))
# 
# numberUnchanged+totalEdits
# nrow(compare_2013_2014)
# 


## plot star of change for different types of changes
## text edit vs distractor edit vs unchanged
## only 2 Major edits in this data set, so not looking at that

# png("items_change/change_by_edit_type.png")
# 
# cols <-  brewer.pal(3,"Dark2") 
# title="Item changes 2013-2014 by type of edit"
# plot <- ggplot() +
#     facet_wrap(~level_14) +
#     geom_segment(data=compare_2013_2014[complete.cases(compare_2013_2014[,"TextEdit"]),], 
#                  mapping=aes(x=0, y=0, xend=time_change, yend=easiness_change,col=level_14))+
#     ggtitle(title) +
#     scale_color_brewer(palette="Dark2", name="category") +  
#     xlab("time change [min]") + 
#     ylab("easiness change")  +
#     theme(plot.title = element_text(size=20, face="bold", vjust=2)) +
#     xlim(c(-5,5)) +
#     ylim(c(-0.5,0.5)) 
# 
# print(plot)
# dev.off()




## compare characteristics of items that have changed with those of items that haven't
  





