install.packages("httpuv", type = "binary")
install.packages("fs", type = "binary")
install.packages("sass", type = "binary")
install.packages("bslib", type = "binary")
library(httpuv)
library(fs)
library(sass)
library(bslib)
install.packages("bit")
library(bit)

install.packages("readr")
library(readr)

# Use the full absolute path to list the files
file_list <- list.files(path = "/Users/anooraagbasu/Documents/HealthDashboard/data/Fitbit_Data", pattern = "*.csv", full.names = TRUE)

# Print the file list to check
file_list

# Read each CSV file into its respective variable dynamically
for (file in file_list) {
  # Extract file name without the extension
  file_name <- gsub(".csv", "", basename(file))
  
  # Read the CSV file and assign it to a variable with the same name as the file (without the extension)
  assign(file_name, read_csv(file))
}

# Example: View the first few rows of one of the datasets, e.g., dailyActivity_merged
head(dailyActivity_merged)

install.packages("RSQLite")
install.packages("DBI")
install.packages("dplyr")
library(RSQLite)
library(DBI)
library(dplyr)
# Create an SQLite database
con <- dbConnect(RSQLite::SQLite(), "healthdashboard.db")

# Loop through each CSV file in the file_list
for (file in file_list) {
  # Extract file name without the extension
  file_name <- gsub(".csv", "", basename(file))
  
  # Read the CSV file into a data frame
  df <- read_csv(file)
  
  # Write the data frame to the SQLite database, dynamically naming the table
  dbWriteTable(con, file_name, df, overwrite = TRUE)
}

tables <- dbListTables(con)
print(tables)

head(dailyActivity_merged)
head(dailyCalories_merged)
head(dailyIntensities_merged)
head(dailySteps_merged)
head(heartrate_seconds_merged)
head(hourlyCalories_merged)
head(hourlyIntensities_merged)
head(hourlySteps_merged)
head(minuteCaloriesNarrow_merged)
head(minuteCaloriesWide_merged)
head(minuteIntensitiesNarrow_merged)
head(minuteIntensitiesWide_merged)
head(minuteMETsNarrow_merged)
head(minuteSleep_merged)
head(minuteStepsNarrow_merged)
head(minuteStepsWide_merged)
head(sleepDay_merged)
head(weightLogInfo_merged)

dbGetQuery(con, "SELECT * FROM dailyActivity_merged LIMIT 10")

# Close the connection after all files are written
dbDisconnect(con)