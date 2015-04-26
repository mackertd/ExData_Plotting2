## Exploratory Data Analysis - Course Project 2 - Plot 6

## Set up the environment

require(dplyr)
require(ggplot2)

## Let the user know the application is starting

print("The application is starting")

## Load RDS File Function

loadfile <- function(directoryPath, filePath) {
      
      ## Form the path; handle the data file is in the same directory as the working directory
      
      if (directoryPath == "" ) {
            
            path <- file.path(filePath)
            
      } else {
            
            path <- file.path(directoryPath, filePath)
            
      }
      
      ## Get the data as data.frame
      
      data <- readRDS(path)
      
      return(data)
      
} ## end loadfile function

## Set the file names and directories for each of the data files

# Current Directory

baseDirectory <- "exdata-data-NEI_data"

# RDS File Name

dataSetFile <- "summarySCC_PM25.rds"

# Load the data file

summaryData <- loadfile(baseDirectory, dataSetFile)

# RDS File Name

dataSetFile <- "Source_Classification_Code.rds"

# Load the data file

sourceData <- loadfile(baseDirectory, dataSetFile)

# Organize the data set

# Filter the data by the  Baltimore City, Maryland (fips == "24510") code

baltimoreData <- filter(summaryData, fips == "24510")

# Filter the data by the  Los Angles County (fips == "06037") code

laCountyData <- filter(summaryData, fips == "06037")

# Filter the list our soruce data by veh by the EI Sector

vehicles <- filter(sourceData, grepl( 'veh', EI.Sector, ignore.case = TRUE))

# Extact the SCC codes for motor vehicles

vehicleSCC <- data.frame(as.character(vehicles$SCC), stringsAsFactors = FALSE)

# Rename the column header for simplicity

colnames(vehicleSCC) <- "SCC"

# Collect each of the motor vehicles types from the Baltimore data set

baltVehicleSummary <- filter(baltimoreData, baltimoreData$SCC %in% vehicleSCC$SCC)

# Collect each of the motor vehicles types from the Los Angles data set

laVehicleSummary <- filter(laCountyData, laCountyData$SCC %in% vehicleSCC$SCC)

# Add the city names

baltVehicleSummary$City <- "Baltimore City"

laVehicleSummary$City <- "Los Angles County"

# Group the data by year

baltGroupedByYear <- group_by(baltVehicleSummary, year, City)

# Group the data by year

laGroupedByYear <- group_by(laVehicleSummary, year, City)

# Summarize the data

baltSummary <- summarise(baltGroupedByYear, total = sum(Emissions))

# Summarize the data

laSummary <- summarise(laGroupedByYear, total = sum(Emissions))

# Combine the data sets

completeSummary <- rbind(baltSummary, laSummary)

# Plot the graph

plot <- ggplot(completeSummary, aes(x = year, y = total, color = City )) + 
      geom_line(group = 1) +
      ggtitle("Motor Vehicle Emissions From Los Angeles and Baltimore City") +
      xlab("Year") +
      ylab("Total Motor Vehicle Emissions")

print(plot)

# Export as PNG

print("Exporting the plot as a PNG")

dev.copy(png, file = "plot6.png", height=480, width=480)
dev.off()

print("Application complete")


