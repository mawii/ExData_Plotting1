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

## Convert Global Active Power column from factor to numeric
x <- as.numeric(levels(hpc$Global_active_power))[hpc$Global_active_power]

## Launch PNG device and create PNG file with dimensions 480px x 480px in
## my working directory
png("plot1.png")

## Plot histogram with red bins, label the x-axis "Global Active Power (kilowatts)",
## and title the histogram "Global Active Power"
hist(x, col = "red", xlab = "Global Active Power (kilowatts)", ylim = c(0, 1200),
     main = "Global Active Power")

dev.off() # Close PNG file device