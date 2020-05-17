library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(pryr)
library(sqldf)

#Step 0: Download and extract files
path <- file.path(getwd(),"test.zip")
if(!file.exists(path))
{
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",path,method = "auto")
}
if (!file.exists(file.path(path,"household_power_consumption.txt"))) { 
  unzip(path,exdir = file.path(getwd())) 
}


#estimating the size of the dataset

# The whole dataset in memory will cost 275 mb
# This was found by using the pryr::object_size function
#> object_size(intitial)
#275 MB

# There are 2075260 rows in the whole 
# each row is about 132 bytes


initial <- read.csv("household_power_consumption.txt",sep = ";",header = TRUE,na.strings="?",nrows=100)
classes <- sapply(initial,class)

full_data <- read.csv("household_power_consumption.txt",sep = ";",header = TRUE,colClasses=classes,na.strings="?")
full_data$Date_Time <- paste(full_data$Date,full_data$Time)

full_data$Date_Time <- dmy_hms(full_data$Date_Time)

filtered_data <- subset(full_data, Date_Time >= as.Date('2007-02-01') & Date_Time < as.Date('2007-02-03'))

png("plot2.png",width=480,height=480)

with(filtered_data,plot(Date_Time,Global_active_power,ylab = "Global Active Power (kilowatts)",type="l",xlab = ""))

dev.off()