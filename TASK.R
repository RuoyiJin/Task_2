#import the data from drive to the RStudio
getwd()
setwd("E:/Task_2")
library("tidyverse")
library("lubridate")
library("ggplot2")
daily_activity <- read.csv("dailyActivity_merged.csv")
sleep_day <- read.csv("sleepDay_merged.csv")
#check the column names, head and compare.
head(daily_activity)
head(sleep_day)
colnames(daily_activity)
colnames(sleep_day)

#let us check the plot of dailyActivity_merged and sleep_day
ggplot(daily_activity)+
  geom_point(mapping = aes(x=TotalSteps, y=SedentaryMinutes,color=Id))
ggplot(sleep_day)+
  geom_point(mapping = aes(x=TotalMinutesAsleep, y=TotalTimeInBed,color=Id))+
  geom_smooth(mapping = aes(x=TotalMinutesAsleep, y=TotalTimeInBed))
# Check how many user we collect in each dataset.
n_distinct(daily_activity$Id)
n_distinct(sleep_day$Id)
#And How many observations are there in each dataframe.
nrow(daily_activity)
nrow(sleep_day)
#check the summary of two dataframe:
daily_activity %>%  
  select(TotalSteps,
         TotalDistance,
         SedentaryMinutes) %>%
  summary()
#__________________________
sleep_day %>%  
  select(TotalSleepRecords,
         TotalMinutesAsleep,
         TotalTimeInBed) %>%
  summary()
#check the str of two files.
str(daily_activity)
str(sleep_day)
# convert the numeric to character
daily_activity <-  mutate(daily_activity, Id = as.character(Id))
str(daily_activity)
sleep_day <-  mutate(sleep_day, Id = as.character(Id))
# note id is a primary key, hence we can combine two datasets by it.
combined_data <- merge(sleep_day, daily_activity, by="Id")

write.csv(combined_data,"E:/Task_2\\combined_data.csv", row.names = FALSE)
