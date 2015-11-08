## Introduction
# Dataset: Electric power consumption [20Mb]
# Description: Measurements of electric power consumption in one household with a one-minute sampling rate over a period of almost 4 years. Different electrical quantities and some sub-metering values are available.
# 1.Date: Date in format dd/mm/yyyy
# 2.Time: time in format hh:mm:ss
# 3.Global_active_power: household global minute-averaged active power (in kilowatt)
# 4.Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# 5.Voltage: minute-averaged voltage (in volt)
# 6.Global_intensity: household global minute-averaged current intensity (in ampere)
# 7.Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
# 8.Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
# 9.Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

## Loading the data
#The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much memory the dataset will require in memory before reading into R. Make sure your computer has enough memory (most modern computers should be fine).
#We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.
#You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
#Note that in this dataset missing values are coded as ?.
if(file.exists("household_power_consumption.txt")) {
  unlink("household_power_consumption.txt")
}
temp <- tempfile()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
file <- unzip(temp)
unlink(temp)
date_download <- date()
day1 <- grep('1/2/2007',readLines(file))[1]
day3 <- grep('3/2/2007',readLines(file))[1]
header <- read.table(file,header=TRUE,sep=";",nrows=1)
hpc <- read.table(file,header=TRUE,sep=";", nrows = day3-day1, skip=day1-2, na.string = "?")
colnames(hpc) <- colnames(header)
summary(hpc)
datetime<-strptime(paste(hpc$Date, hpc$Time, sep=" "),"%d/%m/%Y %H:%M:%S")
hpc<-cbind(datetime,hpc)
## Making Plots
#Our overall goal here is simply to examine how household energy usage varies over a 2-day period in February, 2007.
#Plot4
png(filename='plot4.png',width=480,height=480)
par(mfrow = c(2,2))
with(hpc,plot(datetime,Global_active_power,type="l", col="black", xlab="", ylab="Global Active Power"))
with(hpc,plot(datetime,Voltage,type="l", col="black", xlab="datetime", ylab="Voltage"))
with(hpc,plot(datetime,Sub_metering_1,type="l", col="black", xlab="", ylab="Energy sub metering"))
lines(hpc$datetime,hpc$Sub_metering_2,type="l",col="red")
lines(hpc$datetime,hpc$Sub_metering_3,type="l",col="blue")
legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1,col = c("black", "red", "blue"),bty='n')
with(hpc,plot(datetime,Global_reactive_power,type="l", col="black", xlab="datetime", ylab="Global_reactive_power"))
dev.off()