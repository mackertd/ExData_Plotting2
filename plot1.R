## Exploratory Data Analysis - Course Project 2 - Plot 1

## Set up the environment

require(dplyr)

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

# Group the data

groupedByYear <- group_by(summaryData, year)

# Summarize the data

summary <- summarise(groupedByYear, totals = sum(Emissions) )

# Plot the graph

barplot(summary$totals, names.arg = summary$year, main = "", xlab = "Year", ylab = "Total PM2.5 Emissions", col = rainbow(8:11))
title(main = "PM2.5 Emission totals in the United States from 1999 to 2008")

# Export as PNG

print("Exporting the plot as a PNG")

dev.copy(png, file = "plot1.png", height=480, width=640)
dev.off()

print("Application complete")
