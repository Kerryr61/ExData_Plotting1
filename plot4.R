# Download the file if it is not already on my machine

data_zip_file <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destination_zip_file <- "exdata-data-household_power_consumption.zip"
destination_data_file <- "household_power_consumption.txt"

if(!file.exists(destination_data_file)){
        download.file(data_zip_file, destfile = destination_zip_file)
        unzip(destination_zip_file)
        file.remove(destination_zip_file)
        
}

# ========Format data
# Read in just the days of interest  2007-02-01 and 2007-02-02
library(dplyr)
exdata<- read.csv(destination_data_file, sep = ";", na.strings = "?", colClasses = c("character","character", "numeric","numeric","numeric","numeric","numeric","numeric", "numeric"))
exdata$Date <- as.Date(exdata$Date,"%d/%m/%Y")
exdata <- exdata[(exdata$Date >=as.Date("2007-02-01")) & (exdata$Date <=as.Date("2007-02-02")),]
exdata$DateTime <- paste(exdata$Date, exdata$Time, sep=" ")
exdata$DateTime <- strptime(exdata$DateTime, format="%Y-%m-%d %H:%M:%S", tz="")


# =========Plot=============
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow=c(2,2)) #set the grid

#first plot
plot(exdata$DateTime, exdata$Global_active_power, type = "n", xlab = "", ylab = "Global Active Power (kilowatts)")
lines(exdata$DateTime, exdata$Global_active_power, type="l")

#second plot
plot(exdata$DateTime, exdata$Voltage, type = "n", xlab = "datetime", ylab = "Voltage")
lines(exdata$DateTime, exdata$Voltage, type="l")

#thrid plot
plot(exdata$DateTime, exdata$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
lines(exdata$DateTime, exdata$Sub_metering_1, type="l")
lines(exdata$DateTime, exdata$Sub_metering_2, type="l", col="red")
lines(exdata$DateTime, exdata$Sub_metering_3, type="l", col="blue")
legend("topright", names(exdata[,7:9]), col=c("black","red","blue"), lty=1, cex=.75, bty = "n")

#fouth plot
plot(exdata$DateTime, exdata$Global_reactive_power, type = "n", xlab = "datetime", ylab = "Global_reactive_power")
lines(exdata$DateTime, exdata$Global_reactive_power, type="l")
dev.off()