library(readr)
library(RSQLite)
library(DBI)

# Change or set working directory to the folder with input data
data_file <- "fit.txt"

data <- read_delim(data_file, delim = "\t")

# Updating column names
colnames(data) <- gsub("^#", "", colnames(data))

# Create SQLite connection
con <- dbConnect(RSQLite::SQLite(), "healthdashboard.db")

dbWriteTable(con, "fit_data", data, overwrite = TRUE)

# Querying the database for the first 10 rows
first_10_rows <- dbGetQuery(con, "SELECT * FROM fit_data LIMIT 10")
print("Results after querying the database for the first 10 rows :")
print(first_10_rows)

# Querying the database for the first 10 dates when the user was active
activity_active <- dbGetQuery(con, "SELECT date, active FROM fit_data WHERE active = 'Active' LIMIT 10")
print("Results after querying the database for the first 10 dates when the user was active :")
print(activity_active)

# Querying the database for first 10 rows (by date) when the user slept for 8 hours
sleep_hours_8 <- dbGetQuery(con, "SELECT * FROM fit_data WHERE hours_of_sleep = 8 LIMIT 10")
print("Results after querying the database for first 10 rows (by date) when the user slept for 8 hours :")
print(sleep_hours_8)

# Querying the database for hours of sleep of first 10 rows when the user was happy
mood_happy <- dbGetQuery(con, "SELECT date, hours_of_sleep, mood FROM fit_data WHERE mood = 'Happy' LIMIT 10")
print("Results after querying the database for hours of sleep of first 10 row when the user was happy :")
print(mood_happy)

# Close the database connection
dbDisconnect(con)
