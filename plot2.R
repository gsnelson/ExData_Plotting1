## load required libraries
library(readr)
library(dplyr)
library(tibble)
library(lubridate)


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
## convert the Date & Time variables from character class to date & time classes
## subset on observations occuring on 02-01-2007 & 02-02-2007
## create DateTime & Day (of week) variables
power_subset <-
	read_delim(
		power_data_loc,
		delim = ";",
		col_names = TRUE,
		trim_ws = TRUE,
		skip_empty_rows = TRUE,
		na = "?",
		col_types = cols(
			Date = col_date(format = "%d/%m/%Y"),
			Time = col_time(format = "%T")
		)
	) %>% filter(Date == "2007-02-01" |
				 	Date == "2007-02-02") %>%
	mutate(Day = wday(Date, label = TRUE, abbr = TRUE),
		   DateTime = ymd_hms(paste(Date, Time))) %>%
	select(Date:Time, DateTime, Day, everything())


## remove objects from memory that are no longer needed
rm(data_loc, fileURL, power_data_loc)


## set the graphics parameter to PNG graphics device
png(filename = "plot2.png", width = 480, height = 480, units = "px")


## plot the Global Active Power values
with(
	power_subset,
	plot(
		Global_active_power ~ DateTime,
		lwd = 1,
		type = "l",
		bty = "o",
		ylab = "Global Active Power (kilowatts)",
		xlab = ""
	)
)


## remove objects from memory that are no longer needed
rm(power_subset)


## close the PNG device
dev.off()