# Install and load required packages
install.packages(c("httpuv", "fs", "sass", "bslib", "bit", "readr", "shinydashboard", "RSQLite", "DBI", "dplyr"), type = "binary")
library(httpuv)
library(fs)
library(sass)
library(bslib)
library(bit)
library(readr)
library(shinydashboard)
library(RSQLite)
library(DBI)
library(dplyr)

# Define the directory and get the list of CSV files
file_list <- list.files(path = "/Users/anooraagbasu/Documents/HealthDashboard/data/Fitbit_Data", pattern = "*.csv", full.names = TRUE)

# Read each CSV file and assign to variable dynamically
for (file in file_list) {
  file_name <- gsub(".csv", "", basename(file))
  assign(file_name, read_csv(file))
}

# Create SQLite connection and write data to database
con <- dbConnect(RSQLite::SQLite(), "healthdashboard.db")
for (file in file_list) {
  file_name <- gsub(".csv", "", basename(file))
  df <- read_csv(file)
  dbWriteTable(con, file_name, df, overwrite = TRUE)
}

# Query and print the first 10 rows of a table
query_result <- dbGetQuery(con, "SELECT * FROM dailyActivity_merged LIMIT 10")
print(query_result)

# Close the database connection
dbDisconnect(con)