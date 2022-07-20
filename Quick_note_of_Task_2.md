---
title: "How Can a Wellness Technology Company Play It Smart?"
author: "Ruoyi Jin"
date: "2022-07-19"
output:
  html_document: default
  pdf_document: default
---
### 1. Ask Phase

 * Business Objectives:
  -What are some trends in smart device usage? 
  -How could these trends apply to Bellabeat customers? 
  -How could these trends help influence Bellabeat marketing strategy?
  
 * Stakeholders:
  -Urška Sršen: Bellabeat’s co-founder and Chief Creative Officer
  -Sando Mur: Mathematician and Bellabeat’s co-founder; key member of the Bellabeat executive team
  -Bellabeat marketing analytics team: A team of data analysts responsible for collecting, analyzing, and reporting data that helps guide Bellabeat’s marketing strategy.
  
### 2. Prepare Phase

* Identify:
The data is collected by survey between 03.12.2016-05.12.2016 by via Amazon Mechanical Turk.

* ROCCC:
Reliable: No. The data was collected by survey, the result is not accurate.
Original: No. The data was collected by a third part.
Comprehensive: Yes. The data are clear and easy to read.
Current: No. The survey was 6 years ago.
Cite: No.
* Downloaded and stored to personal hard drive.

### 3. Process Phase:

* Set up my R environment:

  In this progress, I need to Install required packages:
  
  * tidyverse (for data import and wrangling)
  
  * lubridate (for date functions)
  
  * ggplot2 (for visualization)
  
```{r}
library("tidyverse")
library("lubridate")
library("ggplot2")
```
  
* Then, let's create a dataframe named "daily_activity" and "sleep_day" for "dailyActivity_merged.csv" and "sleepDay_merged.csv".

```{r}
daily_activity <- read.csv("dailyActivity_merged.csv")
sleep_day <- read.csv("sleepDay_merged.csv")
```

Take a look at the daily_activity and sleep_day.

```{r}
head(daily_activity)
head(sleep_day)
```

Check how many user we collect in each dataframe.

```{r}
n_distinct(daily_activity$Id)
n_distinct(sleep_day$Id)
```

And How many observations are there in each dataframe.

```{r}
nrow(daily_activity)
nrow(sleep_day)
```

check the summary of two dataframe:

```{r}
print("daily_activity:")
daily_activity %>%  
  select(TotalSteps,
         TotalDistance,
         SedentaryMinutes) %>%
  summary()

print("sleep_day:")
sleep_day %>%  
  select(TotalSleepRecords,
         TotalMinutesAsleep,
         TotalTimeInBed) %>%
  summary()
```

We can Plot a few explorations, but first let's check the structure:

```{r}
str(daily_activity)
str(sleep_day)
```

We find the Id in daily_activity and sleep_day are numeric, we need to both Id to character.

```{r}
daily_activity <-  mutate(daily_activity, Id = as.character(Id))
sleep_day <-  mutate(sleep_day, Id = as.character(Id))
```

Then, we can plot both frame.

```{r}
ggplot(daily_activity)+
  geom_point(mapping = aes(x=TotalSteps, y=SedentaryMinutes,color=Id))
ggplot(sleep_day)+
  geom_point(mapping = aes(x=TotalMinutesAsleep, y=TotalTimeInBed,color=Id))+
  geom_smooth(mapping = aes(x=TotalMinutesAsleep, y=TotalTimeInBed))
```


Compare column names each of the files:
```{r}
colnames(daily_activity)
colnames(sleep_day)
```

* Note that both datasets have the 'Id' field - this can be used to merge the datasets.* 
Here, by "Id" we can apply:

```{r}
combined_data <- merge(sleep_day, daily_activity, by="Id")
```

Take a look at how many participants are in this data set.

```{r}
n_distinct(combined_data$Id)
```

Check the structure and convert the Id to character:
```{r}
str(combined_data)
```

### 4. Analysis Phase
* Check the total number of users:
  Then we can use the BigQuery to analysis the data.
  Here we can apply:
  
```
SELECT                                          
  COUNT(*) AS TOTAL_DATA                        
FROM                                            
  `task2-356801.FitBit.combined_data`           
 ```
  We have total 12441 rows.

```
SELECT                                         
  COUNT(DISTINCT(Id)) AS num_of_user           
FROM                                           
  `task2-356801.FitBit.combined_data`          
 
  We have totally 24 users's data.
```

* Check how many day per user report:

```
SELECT                                              
  Id,                                                 
  COUNT(DISTINCT(ActivityDate)) AS TOTAL_REPORT_DAY 
FROM                                                  
  `task2-356801.FitBit.combined_data`                 
GROUP BY                                            
  Id                                                
ORDER BY                                                    
  TOTAL_REPORT_DAY DESC                             
```
  We have 16 users upload the data 31 days, one user upload 18 days.

* Want to know the average of report date:
```
SELECT                                                   
  AVG(TOTAL_REPORT_DAY) AS average                       
FROM                                                     
  (                                                      
    SELECT                                               
      COUNT(DISTINCT(ActivityDate)) AS TOTAL_REPORT_DAY  
    FROM                                                 
      `task2-356801.FitBit.combined_data`                
  )
 ```
By now, we know the average date of each user is 31 days.

