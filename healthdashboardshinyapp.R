library(shiny)
library(ggplot2)
library(DT)
library(shinydashboard)
library(shinyWidgets)
library(lubridate)
library(RSQLite)
library(DBI)
library(dplyr)

# SQLite database connection
con <- dbConnect(RSQLite::SQLite(), "healthdashboard.db")

# Read data from SQLite database
data <- dbGetQuery(con, "SELECT * FROM fit_data")

# Ensure column names are correct
colnames(data) <- gsub("^#", "", colnames(data))

# Convert the date column properly
data$date <- as.character(data$date)  # Ensure it's character first
data$date <- as.Date(data$date, format="%d-%m-%Y")  # Convert to Date

# Get min and max dates
min_date <- min(data$date)
max_date <- max(data$date)

# Close the database connection
dbDisconnect(con)

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Fitbit Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Steps", tabName = "steps", icon = icon("shoe-prints")),
      menuItem("Mood", tabName = "mood", icon = icon("smile")),
      menuItem("Calories", tabName = "calories", icon = icon("fire")),
      menuItem("Hours of Sleep", tabName = "sleep", icon = icon("bed")),
      menuItem("Activity", tabName = "activity", icon = icon("running"))
    )
  ),
  dashboardBody(
    tabItems(
      # Steps Tab
      tabItem(tabName = "steps",
              fluidRow(
                box(title = "Steps Over Time", width = 12, status = "primary",
                    dateRangeInput("steps_date", "Select Date Range:",
                                   start = min_date, end = max_date,
                                   min = min_date, max = max_date),
                    plotOutput("steps_plot"))
              )
      ),
      # Mood Tab
      tabItem(tabName = "mood",
              fluidRow(
                box(title = "Mood Analysis", width = 6, status = "primary",
                    dateInput("mood_date", "Select Specific Date:", value = max_date,
                              min = min_date, max = max_date),
                    plotOutput("mood_pie")),
                box(title = "Monthly Mood Distribution", width = 6, status = "primary",
                    selectInput("mood_month", "Select Month & Year:",
                                choices = unique(format(data$date, "%Y-%m")),
                                selected = format(max_date, "%Y-%m")),
                    plotOutput("mood_monthly_pie"))
              )
      ),
      # Calories Tab
      tabItem(tabName = "calories",
              fluidRow(
                box(title = "Calories Burned Over Time", width = 12, status = "primary",
                    dateRangeInput("calories_date", "Select Date Range:",
                                   start = min_date, end = max_date,
                                   min = min_date, max = max_date),
                    plotOutput("calories_plot"))
              )
      ),
      # Hours of Sleep Tab
      tabItem(tabName = "sleep",
              fluidRow(
                box(title = "Hours of Sleep Over Time", width = 12, status = "primary",
                    dateRangeInput("sleep_date", "Select Date Range:",
                                   start = min_date, end = max_date,
                                   min = min_date, max = max_date),
                    plotOutput("sleep_plot"))
              )
      ),
      # Activity Tab
      tabItem(tabName = "activity",
              fluidRow(
                box(title = "Activity Level", width = 6, status = "primary",
                    dateInput("activity_date", "Select Specific Date:", value = max_date,
                              min = min_date, max = max_date),
                    plotOutput("activity_pie")),
                box(title = "Monthly Activity Distribution", width = 6, status = "primary",
                    selectInput("activity_month", "Select Month & Year:",
                                choices = unique(format(data$date, "%Y-%m")),
                                selected = format(max_date, "%Y-%m")),
                    plotOutput("activity_monthly_pie"))
              )
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Filtered dataset based on date input
  filtered_data <- reactive({
    data
  })
  
  # Steps plot
  output$steps_plot <- renderPlot({
    filtered_steps <- data %>% filter(date >= input$steps_date[1] & date <= input$steps_date[2])
    ggplot(filtered_steps, aes(x = date, y = step_count)) +
      geom_line(color = "blue") +
      labs(title = "Steps Over Time", x = "Date", y = "Step Count")
  })
  
  # Mood Pie Chart (Specific Date)
  output$mood_pie <- renderPlot({
    mood_data <- data %>% filter(date == input$mood_date)
    ggplot(mood_data, aes(x = "", fill = mood)) +
      geom_bar(width = 1, stat = "count") +
      coord_polar("y") +
      labs(title = paste("Mood Distribution on", input$mood_date), fill = "Mood") +
      theme_void()
  })
  
  # Mood Pie Chart (Monthly)
  output$mood_monthly_pie <- renderPlot({
    monthly_data <- data %>%
      filter(format(date, "%Y-%m") == input$mood_month)
    ggplot(monthly_data, aes(x = "", fill = mood)) +
      geom_bar(width = 1, stat = "count") +
      coord_polar("y") +
      labs(title = paste("Mood Distribution in", input$mood_month), fill = "Mood") +
      theme_void()
  })
  
  # Calories plot
  output$calories_plot <- renderPlot({
    filtered_calories <- data %>% filter(date >= input$calories_date[1] & date <= input$calories_date[2])
    ggplot(filtered_calories, aes(x = date, y = calories_burned)) +
      geom_line(color = "red") +
      labs(title = "Calories Burned Over Time", x = "Date", y = "Calories Burned")
  })
  
  # Sleep plot
  output$sleep_plot <- renderPlot({
    filtered_sleep <- data %>% filter(date >= input$sleep_date[1] & date <= input$sleep_date[2])
    ggplot(filtered_sleep, aes(x = date, y = hours_of_sleep)) +
      geom_line(color = "purple") +
      labs(title = "Hours of Sleep Over Time", x = "Date", y = "Hours of Sleep")
  })
  
  # Activity Pie Chart (Specific Date)
  output$activity_pie <- renderPlot({
    activity_data <- data %>% filter(date == input$activity_date)
    ggplot(activity_data, aes(x = "", fill = active)) +
      geom_bar(width = 1, stat = "count") +
      coord_polar("y") +
      labs(title = paste("Activity Level on", input$activity_date), fill = "Activity") +
      theme_void()
  })
  
  # Activity Pie Chart (Monthly)
  output$activity_monthly_pie <- renderPlot({
    monthly_data <- data %>%
      filter(format(date, "%Y-%m") == input$activity_month)
    ggplot(monthly_data, aes(x = "", fill = active)) +
      geom_bar(width = 1, stat = "count") +
      coord_polar("y") +
      labs(title = paste("Activity Distribution in", input$activity_month), fill = "Activity") +
      theme_void()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
