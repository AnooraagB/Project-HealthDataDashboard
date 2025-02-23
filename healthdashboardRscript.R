library(readr)
library(RSQLite)
library(DBI)

data_file <- "fit.txt"

data <- read_delim(data_file, delim = "\t")

# Create SQLite connection
con <- dbConnect(RSQLite::SQLite(), "healthdashboard.db")

dbWriteTable(con, "fit_data", data, overwrite = TRUE)

# Query and print first 10 rows
query_result <- dbGetQuery(con, "SELECT * FROM fit_data LIMIT 10")
print(query_result)

# Close the database connection
dbDisconnect(con)
