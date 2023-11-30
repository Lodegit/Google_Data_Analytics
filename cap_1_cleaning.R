##### Capstone Project 1 Bike sharing company #####
## Data cleaning ##

# Installing needed packages for analysis and cleaning
#install.packages("tidyverse")
#install.packages("janitor")
#install.packages("lubridate")

# Loading said packages
library(janitor)
library(lubridate)
library(tidyverse)

# load data all into separate variables because the files only existed monthwise
jan <- read_csv("202201-divvy-tripdata.csv")
feb <- read_csv("202202-divvy-tripdata.csv")
mar <- read_csv("202203-divvy-tripdata.csv")
apr <- read_csv("202204-divvy-tripdata.csv")
may <- read_csv("202205-divvy-tripdata.csv")
jun <- read_csv("202206-divvy-tripdata.csv")
jul <- read_csv("202207-divvy-tripdata.csv")
aug <- read_csv("202208-divvy-tripdata.csv")
sep <- read_csv("202209-divvy-tripdata.csv")
oct <- read_csv("202210-divvy-tripdata.csv")
nov <- read_csv("202211-divvy-tripdata.csv")
dec <- read_csv("202212-divvy-tripdata.csv")

# merge the data frames into one with bind_rows
data <- bind_rows(jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)
#rm(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec) # removing the months to reduce clutter

# clean the data by removing the empty spaces, columns, parentheses etc
remove_empty(data, which = c()) # removing empty columns and rows
data <- clean_names(data) # removing empty spaces and parentheses

# get the day for each data point (it is important to know which weekday it was)
# we also need the time in a separate column as well as the month
Sys.setlocale("LC_TIME", "C") # set the locale to English otherwise the abbr would be in German
data$day_of_week <- wday(data$started_at, label = T, abbr = T)
data$starting_hour <- format(as.POSIXct(data$started_at), '%H')
data$month <- format(as.Date(data$started_at), '%m')

# Trip duration with diff time, this will be our main metric 
data$trip_duration <- difftime(data$ended_at, data$started_at, units='sec')

# Now we make a new dataframe that include all trips with a duration > 0 
data <- data[!(data$trip_duration<=0),]

# Save the data, also as a csv file for later Tableau use
save(data, file='data.Rda')
write.csv(data, file = "cycle_data.csv")


# This concludes the cleaning steps for the data. Now it is ready for analysis