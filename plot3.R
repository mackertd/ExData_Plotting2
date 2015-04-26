## Exploratory Data Analysis - Course Project 2 - Plot 3

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

# Group the data by year

groupedByType <- group_by(baltimoreData, year, type)

# Summarize the data

summary <- summarise(groupedByType, total = sum(Emissions))

# Plot the graph

plot <- ggplot(summary, aes(x = year, y = total, color = type )) + 
      geom_line(group = 1) +
      ggtitle("Baltimore City Emissions By Type") +
      xlab("Year") +
      ylab("Total Emissions")
      
print(plot)

# Export as PNG

print("Exporting the plot as a PNG")

dev.copy(png, file = "plot3.png", height=480, width=640)
dev.off()

print("Application complete")


