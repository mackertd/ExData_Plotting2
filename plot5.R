## Exploratory Data Analysis - Course Project 2 - Plot 5

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

# Filter the list our soruce data by veh by the EI Sector

vehicles <- filter(sourceData, grepl( 'veh', EI.Sector, ignore.case = TRUE))

# Extact the SCC codes for motor vehicles

vehicleSCC <- data.frame(as.character(vehicles$SCC), stringsAsFactors = FALSE)

# Rename the column header for simplicity

colnames(vehicleSCC) <- "SCC"

# Collect each of the coal combusiton types from the summary data set

vehicleSummary <- filter(baltimoreData, baltimoreData$SCC %in% vehicleSCC$SCC)

# Group the data by year

groupedByYear <- group_by(vehicleSummary, year)

# Summarize the data

summary <- summarise(groupedByYear, total = sum(Emissions))

# Plot the graph

plot <- ggplot(summary, aes(x = factor(year), y = total, fill = year)) + 
      geom_bar(stat = "identity") +
      ggtitle("Total Motor Vehicle Emissions in Baltimore City, Maryland") +
      xlab("Year") +
      ylab("Total Vehicle Emissions")

print(plot)

# Export as PNG

print("Exporting the plot as a PNG")

dev.copy(png, file = "plot5.png", height=480, width=640)
dev.off()

print("Application complete")


