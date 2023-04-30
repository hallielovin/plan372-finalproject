rm(list=ls(all=TRUE))

library(tidyverse)
library(sf)

#load in the block groups data used in hw3 
block_groups <- read_sf("hw3-data/orange_durham_wake_block_groups.shp")

#transfrom the block groups so they fit the NC Projection
block_groups <- st_transform(block_groups,32119)

#subset this data so it only includes orange county 
orange_county <- subset(block_groups, COUNTYFP == 135)

#Make sure that the subset works when turning it into a map
ggplot() + 
  geom_sf(data=orange_county)

#load in the demographic data 
census = read_csv( "hw3-data/triangle_census.csv",
                   col_types=c(GEOID="character"))

#add the demographic data to the orange county data file 
library(dplyr)

orange_county <- left_join(orange_county, census, by = join_by(GEOID == GEOID))

#export the map of wake county so I can use it in my mapping in QGIS 
write_sf(orange_county, "orange_county.shp")

#Find the percentage of different demographic variables in orange county 
no_vehicle <-sum(orange_county$zero_vehicle_households)/sum(orange_county$total_households) 
#5.3% of households in orange county have no vehicles

seniors <- sum(orange_county$seniors_65plus)/sum(orange_county$total_households) 
#36% of orange county consists of seniors over 65

lowincome <- sum(orange_county$households_income_less_than_35k)/sum(orange_county$total_households) 
#25% of households in orange county are considered low income 

#Make a new data frame with the demographic characteristic and the percentages 
Percentage <- c(5.3, 36.4, 25.2)
Demographic <- c("No Vehicle Household", "Seniors 65 Plus", "Low Income")

demographics <- data.frame(Demographic, Percentage)

ggplot(demographics, aes(Demographic, Percentage)) + geom_col()

#Find the total population 
sum(orange_county$total_population)

#find the total number of people without a car 
.53*144836

