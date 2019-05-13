## Create directory if none exists. Then, download data if not already downloaded.
if(!file.exists("./epc-data")) {dir.create("./epc-data")}
if(!file.exists("./epc-data/household_power_consumption.txt")) {
  temp <- tempfile() # opens connection with temp file
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile = temp)
  unzip(temp, exdir = "./epc-data") # extracts contents to "epc-data" folder
  unlink(temp) # closes connection with temp file
}

## Each row of data represents 1 minute, so
## nrows = 60 mins/hr * 24 hrs/day * 2 days = 2880. Data from 01/02/2007 to 02/02/2007
## starts on line 66637, so skipping the first 66,636 lines and only reading 2,880
## lines into R will conserve some data.
hpc <- read.csv2("./epc-data/household_power_consumption.txt", nrows = 2880, skip = 66636,
                 col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power",
                               "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2",
                               "Sub_metering_3"))

## Convert Date and Time variables to Date/Time class using strptime(). Then
## convert Global Active Power column from factor to numeric.
x <- strptime(paste(hpc$Date, hpc$Time), "%d/%m/%Y %H:%M:%S")

## Launch PNG device and create PNG file with dimensions 480px x 480px in
## my working directory
png("plot3.png")

## Plot datetime line graph and label the y-axis "Energy sub metering"
with(hpc, {
  plot(x, as.numeric(levels(Sub_metering_1))[Sub_metering_1], type = "l",
       xlab = "", ylab = "Energy sub metering")
  points(x, as.numeric(levels(Sub_metering_2))[Sub_metering_2], type = "l", col = "red")
  points(x, as.numeric(levels(Sub_metering_3))[Sub_metering_3], type = "l", col = "blue")
  legend("topright", lty = 1, col = c("black", "blue", "red"), legend = names(hpc)[-1:-6],
         cex = 0.75)
})

dev.off() # Close PNG file device