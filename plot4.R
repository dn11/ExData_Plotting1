#------------------------------------------------------------------------------
# This function loads the individual household electric power comsumption
# data set (Source: UC Irvine Machine Learning Repository) and creates 4 graphs
# for the dates 2007-02-01 and 2007-02-02. The first graph shows the global
# active power over time. The second graph shows the voltage over time. The 
# third graph shows the sub metering 1, 2, and 3 over time. The fourth graph 
# shows the global reactive power over time.
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
SubMetering1<-as.numeric(data$Sub_metering_1)
SubMetering2<-as.numeric(data$Sub_metering_2)
SubMetering3<-as.numeric(data$Sub_metering_3)
voltage<-as.numeric(data$Voltage)
GlobalReactivePower<-as.numeric(data$Global_reactive_power)

# create the datetime
dates<-data$Date
times<-data$Time
dateTimes<-as.POSIXct(strptime(paste(dates,times), "%Y-%m-%d %H:%M:%S"))

## Plot 4
# open PNG device
png(file="plot4.png",width=480,height=480)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

# Add plot 1: Global Active Power (kilowatts)
plot(dateTimes,globalActivePower,ylab="Global Active Power",
     xlab="",main="",type="l")

# Add plot 2: Voltage
plot(dateTimes,voltage,ylab="Voltage",
     xlab="datetime",main="",type="l")

# Add plot 3: Energy sub metering
# set the y-axis range (x-axis range is the same)
yRange<-range(c(SubMetering1,SubMetering2,SubMetering3))
# -first line
plot(dateTimes,SubMetering1,ylab="Energy sub metering",
     xlab="",main="",type="l",col="black",
     ylim=yRange)
# -second line
lines(dateTimes,SubMetering2,ylab="",
      xlab="",main="",type="l",col="red",
      ylim=yRange)
# -third line
lines(dateTimes,SubMetering3,ylab="",
      xlab="",main="",type="l",col="blue",
      ylim=yRange)
# add legend
legend("topright", lty=c(1,1,1), col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2",
                  "Sub_metering_3"),bty="n")

# Add plot 4: Global reactive power
plot(dateTimes,GlobalReactivePower,ylab="Global_reactive_power",
     xlab="datetime",main="",type="l")

# close the PNG device
dev.off()