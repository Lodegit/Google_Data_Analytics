###### Data Analysis ######

library(tidyverse)
library(janitor)
library(lubridate)

# load the data
load("data.Rda")



# Now it is time for plots that will eventually show the results and the conclusion
# of this data set. 

# We use options(scipen =) to remove scientific values from our graphs (as the total number of trips will become very big)
# (position = 'dodge') in laymans term, will essentially inform the 2nd value (in this case member type) to 'dodge' and not stack ontop. Instead it will be displayed alongside the x- axis.

options(scipen = 999)
ggplot(data = data) +
  aes(x = day_of_week, fill = member_casual) +
  geom_bar(position = 'dodge') +
  labs(x = 'Day of week', y = 'Number of rides', fill = 'Member type', title = 'Number of rides by member type')

# ggsave("number_of_rides_by_member_type.png") #this will save the small plot (zoom -> save as)

# As the week progresses the number of casual riders drops and members start to rise. Casual riders tend to ride
# mainly on Weekends where as members tend to ride during the week.

ggplot(data = data) +
  aes(x = month, fill = member_casual) +
  geom_bar(position = 'dodge') +
  labs(x = 'Month', y = 'Number of rides', fill = 'Member type', title = 'Number of rides per month')

#ggsave("number_of_rides_per_month.png") #same story as above

# We can also clearly see the expected distribution of rides during the year. Obviously more rides in the summer
# months. We also notice that the members ride in the cold months as well, further showing how the two groups 
# use the bikes.

# We remove 'dodge' as there are already so many charts due to facet_wrap
# Facet_wrap() essentially creates a long ribbon of panels
# element_text(size=) would allow us to reduce our text size to fit our charts
# dpi allows us to essentially save our chart into higher res, so it be viewed in a larger window more clearly

ggplot(data = data) +
  aes(x = starting_hour, fill = member_casual) +
  facet_wrap(~day_of_week) +
  geom_bar() +
  labs(x = 'Starting hour', y = 'Number of rides', fill = 'Member type', title = 'Hourly use of bikes throughout the week') +
  theme(axis.text = element_text(size = 5))

ggsave("Hourly_use_of_bikes_throughout_the_week.png", dpi = 1000)

# I am having trouble visualizing the average trip duration of members and casuals on each day.
# Because of this I am creating a table which shows those values.
avg_trip <- aggregate(data$trip_duration ~ data$member_casual + data$day_of_week, FUN = mean)
colnames(avg_trip)[1] <- "member_casual"
colnames(avg_trip)[2] <- "day_of_the_week"
colnames(avg_trip)[3] <- "average_trip_duration"


# I tried to visualize this table but I am still failing
ggplot(data = avg_trip) + 
  aes(x = day_of_the_week, y = average_trip_duration, fill = member_casual) +
  geom_bar(position="dodge") +
  labs(x = 'Day of the Week', y = 'Average trip duration', fill = 'Member type', title = 'Average trip duration by member type') +
  theme(axis.text = element_text(size = 5))
  
# write.csv(avg_trip, file = "avg_trip.csv")
