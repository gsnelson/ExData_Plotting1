## load required libraries
library(data.table)


## instantiate variables
fileURL <-
	"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_loc <- ".data/exdata_data_household_power_consumption.zip"
power_data_loc <- ".data/household_power_consumption.txt"


## check for data folder / create if necessary
if (!file.exists(".data")) {
	dir.create(".data")
}


## download data zip file to data folder, unzip it and then delete zip file
download.file(fileURL, destfile = data_loc)
unzip(data_loc, exdir = ".data")
if (file.exists(data_loc))
	file.remove(data_loc)


## read household power consumption data into the power_data dataframe object
power_data <- read.table(
	power_data_loc,
	header = TRUE,
	sep = ";",
	na.strings = "?",
	strip.white = FALSE,
	blank.lines.skip = TRUE,
	check.names = TRUE
)


## reformat the date variable
power_data$Date <- strptime(power_data$Date, "%d/%m/%Y")


## subset on observations occuring on 02-01-2007 & 02-02-2007
power_subset <-
	subset(power_data, Date == "2007-02-01" | Date == "2007-02-02")


## remove objects from memory that are no longer needed
rm(power_data, data_loc, fileURL, power_data_loc)


## plot the Global Active Power values
hist(
	power_subset$Global_active_power,
	col = "red",
	xlab = "Global Active Power (kilowatts)",
	main = "Global Active Power"
)


## remove objects from memory that are no longer needed
rm(power_subset)


## copy plot to a PNG file
dev.print(device = png, file = "plot1.png", width = 480, height = 480)


## close the PNG device
dev.off()