# Run the application
shinyApp(ui = ui, server = server)

library(shiny)
library(DBI)
library(RSQLite)
library(dplyr)
library(ggplot2)
library(shinydashboard)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Fitbit Health Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Activity", tabName = "activity", icon = icon("running")),
      menuItem("Heart Rate", tabName = "heartrate", icon = icon("heartbeat")),
      menuItem("Calories", tabName = "calories", icon = icon("fire")),
      menuItem("Sleep", tabName = "sleep", icon = icon("bed")),
      menuItem("Weight & BMI", tabName = "weight", icon = icon("weight"))
    )
  ),
  dashboardBody(
    tabItems(
      # Activity Tab
      tabItem(tabName = "activity",
              fluidRow(
                box(title = "Filters", status = "primary", solidHeader = TRUE, 
                    selectInput("activity_metric", "Select Activity:",
                                choices = c("Total Steps", "Total Distance", "Very Active Minutes")),
                    dateRangeInput("activity_date", "Date Range:",
                                   start = "2016-01-01", end = Sys.Date()),
                    actionButton("activity_update", "Update View")
                ),
                box(title = "Activity Trends", status = "info", solidHeader = TRUE, 
                    plotOutput("activity_plot"))
              )
      ),
      # Heart Rate Tab
      tabItem(tabName = "heartrate",
              fluidRow(
                box(title = "Filters", status = "primary", solidHeader = TRUE, 
                    dateRangeInput("hr_date", "Date Range:",
                                   start = "2016-01-01", end = Sys.Date()),
                    actionButton("hr_update", "Update View")
                ),
                box(title = "Heart Rate Trends", status = "info", solidHeader = TRUE, 
                    plotOutput("hr_plot"))
              )
      ),
      # Calories Tab
      tabItem(tabName = "calories",
              fluidRow(
                box(title = "Filters", status = "primary", solidHeader = TRUE, 
                    dateRangeInput("cal_date", "Date Range:",
                                   start = "2016-01-01", end = Sys.Date()),
                    actionButton("cal_update", "Update View")
                ),
                box(title = "Calories Burned", status = "info", solidHeader = TRUE, 
                    plotOutput("cal_plot"))
              )
      ),
      # Sleep Tab
      tabItem(tabName = "sleep",
              fluidRow(
                box(title = "Filters", status = "primary", solidHeader = TRUE, 
                    dateRangeInput("sleep_date", "Date Range:",
                                   start = "2016-01-01", end = Sys.Date()),
                    actionButton("sleep_update", "Update View")
                ),
                box(title = "Sleep Patterns", status = "info", solidHeader = TRUE, 
                    plotOutput("sleep_plot"))
              )
      ),
      # Weight Tab
      tabItem(tabName = "weight",
              fluidRow(
                box(title = "Filters", status = "primary", solidHeader = TRUE, 
                    dateRangeInput("weight_date", "Date Range:",
                                   start = "2016-01-01", end = Sys.Date()),
                    actionButton("weight_update", "Update View")
                ),
                box(title = "Weight & BMI", status = "info", solidHeader = TRUE, 
                    plotOutput("weight_plot"))
              )
      )
    )
  )
)

# Define Server Logic
server <- function(input, output, session) {
  con <- dbConnect(RSQLite::SQLite(), "healthdashboard.db")
  
  fetch_data <- function(query) {
    dbGetQuery(con, query)
  }
  
  # Activity Data
  output$activity_plot <- renderPlot({
    req(input$activity_update)
    data <- fetch_data(paste("SELECT ActivityDate,", input$activity_metric, "FROM dailyActivity_merged",
                             "WHERE ActivityDate BETWEEN '", input$activity_date[1], "' AND '", input$activity_date[2], "'"))
    ggplot(data, aes(x = ActivityDate, y = get(input$activity_metric))) + geom_line() + theme_minimal()
  })
  
  # Heart Rate Data
  output$hr_plot <- renderPlot({
    req(input$hr_update)
    data <- fetch_data(paste("SELECT Time, HeartRate FROM heartrate_seconds_merged",
                             "WHERE Time BETWEEN '", input$hr_date[1], "' AND '", input$hr_date[2], "'"))
    ggplot(data, aes(x = Time, y = HeartRate)) + geom_line() + theme_minimal()
  })
  
  # Calories Data
  output$cal_plot <- renderPlot({
    req(input$cal_update)
    data <- fetch_data(paste("SELECT ActivityDate, Calories FROM dailyCalories_merged",
                             "WHERE ActivityDate BETWEEN '", input$cal_date[1], "' AND '", input$cal_date[2], "'"))
    ggplot(data, aes(x = ActivityDate, y = Calories)) + geom_line() + theme_minimal()
  })
  
  # Sleep Data
  output$sleep_plot <- renderPlot({
    req(input$sleep_update)
    data <- fetch_data(paste("SELECT SleepDay, TotalMinutesAsleep FROM sleepDay_merged",
                             "WHERE SleepDay BETWEEN '", input$sleep_date[1], "' AND '", input$sleep_date[2], "'"))
    ggplot(data, aes(x = SleepDay, y = TotalMinutesAsleep)) + geom_line() + theme_minimal()
  })
  
  # Weight Data
  output$weight_plot <- renderPlot({
    req(input$weight_update)
    data <- fetch_data(paste("SELECT Date, WeightKg FROM weightLogInfo_merged",
                             "WHERE Date BETWEEN '", input$weight_date[1], "' AND '", input$weight_date[2], "'"))
    ggplot(data, aes(x = Date, y = WeightKg)) + geom_line() + theme_minimal()
  })
  
  onStop(function() { dbDisconnect(con) })
}

# Run App
shinyApp(ui, server)