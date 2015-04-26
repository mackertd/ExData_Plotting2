## Exploratory Data Analysis - Course Project 2 - Plot 4

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

# Filter the list our soruce data by Coal|Coal by the EI Sector

coalCombustion <- filter(sourceData, grepl( 'coal', EI.Sector, ignore.case=TRUE))

# Extact the SCC codes for coal and combustion

coalSCC <- data.frame(as.character(coalCombustion$SCC), stringsAsFactors = FALSE)

# Rename the column header for simplicity

colnames(coalSCC) <- "SCC"

# Collect each of the coal combusiton types from the summary data set

coalSummary <- filter(summaryData, summaryData$SCC %in% coalSCC$SCC)

# Group the data by year

groupedByYear <- group_by(coalSummary, year)

# Summarize the data

summary <- summarise(groupedByYear, total = sum(Emissions))

# Plot the graph

plot <- ggplot(summary, aes(x = factor(year), y = total, fill = year)) + 
      geom_bar(stat = "identity") +
      ggtitle("Coal Emissions Acrosss The United States") +
      xlab("Year") +
      ylab("Total Coal Emissions")

print(plot)

# Export as PNG

print("Exporting the plot as a PNG")

dev.copy(png, file = "plot4.png", height=480, width=640)
dev.off()

print("Application complete")


