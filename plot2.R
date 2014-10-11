#------------------------------------------------------------------------------
# This function loads the individual household electric power comsumption
# data set (Source: UC Irvine Machine Learning Repository) and creates a 
# time series of the global active power for the dates 2007-02-01 and 
# 2007-02-02
#------------------------------------------------------------------------------
# The dataset has the following variables:
# 1.Date: Date in format dd/mm/yyyy 
# 2.Time: time in format hh:mm:ss 
# 3.Global_active_power: household global minute-averaged active power (in 
#   kilowatt) 
# 4.Global_reactive_power: household global minute-averaged reactive power 
#   (in kilowatt) 
# 5.Voltage: minute-averaged voltage (in volt) 
# 6.Global_intensity: household global minute-averaged current intensity (in 
#   ampere) 
# 7.Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
#   It corresponds to the kitchen, containing mainly a dishwasher, an oven and 
#   a microwave (hot plates are not electric but gas powered). 
# 8.Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). 
#   It corresponds to the laundry room, containing a washing-machine, a 
#   tumble-drier, a refrigerator and a light. 
# 9.Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
#   It corresponds to an electric water-heater and an air-conditioner.
#------------------------------------------------------------------------------

# load the data.table library
library(data.table)

# set the directory
setwd("/Users/dgn2/Documents/RStudio/work/Exploratory Data Analysis")

# get the directory
workDirectory<-getwd()

# directory and file name
folder<-"data"
fileName="household_power_consumption.txt"
dataDirectory<-paste(workDirectory,folder,sep = "/")
fileNameFullPath<-paste(workDirectory,folder,fileName,sep = "/")

## read the data
DT=fread(fileNameFullPath,header=TRUE, sep=";",na.strings="?")

## convert the dates
DT[,Date:=as.IDate(DT$Date,"%d/%m/%Y")]
DT[,Time:=as.ITime(DT$Time)]

## subset the data (include only data from Feb 1 and Feb 2 2007)
data<-DT[DT$Date=="2007-02-01"|DT$Date==" 2007-02-02",]

## extract data for graphs
globalActivePower<-as.numeric(data$Global_active_power)
dates<-data$Date
times<-data$Time

# create the datetime
dateTimes<-as.POSIXct(strptime(paste(dates,times), "%Y-%m-%d %H:%M:%S"))

## Create Plot 2
# open PNG device
png(file="plot2.png",width=480,height=480)
# Global Active Power (kilowatts)
plot(dateTimes,globalActivePower,ylab="Global Active Power (kilowatts)",
     xlab="",main="",type="l")

# close the PNG device
dev.off()
