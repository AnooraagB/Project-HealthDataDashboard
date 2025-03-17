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
  dashboardHeader(title = "Health Data Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),  # Home menu item
      menuItem("Steps", tabName = "steps", icon = icon("shoe-prints")),
      menuItem("Mood", tabName = "mood", icon = icon("smile")),
      menuItem("Calories", tabName = "calories", icon = icon("fire")),
      menuItem("Hours of Sleep", tabName = "sleep", icon = icon("bed")),
      menuItem("Activity", tabName = "activity", icon = icon("running")),
      menuItem("Full Data", tabName = "full_data", icon = icon("database"))  # Full data menu item
    )
  ),
  dashboardBody(
    tabItems(
      # Home Tab
      tabItem(tabName = "home", 
              fluidRow(
                box(title = strong("Welcome to the Health Data Dashboard"), width = 12, status = "primary",
                    p("by Anooraag Basu"),
                    p("MSc Bioinformatics student at The University of Edinburgh"),
                    p("Digital Skills Specialists Edinburgh Award Project"),
                    p(strong("How to use:")),
                    p("1. Use the menu on the left to navigate between different data views (Steps, Mood, Calories, Sleep, Activity)."),
                    p("2. Select the desired date range or specific date to filter the data."),
                    p("3. Visualizations will be updated dynamically based on your selections.")
                )
              )
      ),
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
                box(title = "Mood on Selected Date", width = 12, status = "primary",
                    dateInput("mood_date", "Select Specific Date:", value = max_date,
                              min = min_date, max = max_date),
                    uiOutput("mood_display")
                )
              ),
              fluidRow(
                box(title = "Monthly Mood Distribution", width = 12, status = "primary",
                    selectInput("mood_month", "Select Month & Year:",
                                choices = unique(format(data$date, "%Y-%m")),
                                selected = format(max_date, "%Y-%m")),
                    plotOutput("mood_monthly_pie")
                )
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
                box(title = "Activity on Selected Date", width = 12, status = "primary",
                    dateInput("activity_date", "Select Specific Date:", value = max_date,
                              min = min_date, max = max_date),
                    uiOutput("activity_display")
                )
              ),
              fluidRow(
                box(title = "Monthly Activity Distribution", width = 12, status = "primary",
                    selectInput("activity_month", "Select Month & Year:",
                                choices = unique(format(data$date, "%Y-%m")),
                                selected = format(max_date, "%Y-%m")),
                    plotOutput("activity_monthly_pie")
                )
              )
      ),
      # Full Data Tab (New)
      tabItem(tabName = "full_data",
              fluidRow(
                box(title = "Full Fitbit Data", width = 12, status = "primary",
                    DTOutput("full_data_table")  # Display the data in a table
                )
              )
      )
    )
  )
)

# Server
server <- function(input, output) {
  # Steps plot
  output$steps_plot <- renderPlot({
    filtered_steps <- data %>% filter(date >= input$steps_date[1] & date <= input$steps_date[2])
    ggplot(filtered_steps, aes(x = date, y = step_count)) +
      geom_line(color = "blue") +
      labs(title = "Steps Over Time", x = "Date", y = "Step Count")
  })
  
  # Mood Display
  output$mood_display <- renderUI({
    mood_data <- data %>% filter(date == input$mood_date)
    if (nrow(mood_data) == 0) return("No data available")
    mood <- mood_data$mood[1]
    icon_name <- ifelse(mood == "Happy", "smile", ifelse(mood == "Neutral", "meh", "frown"))
    tagList(icon(icon_name), strong(mood))
  })
  
  # Mood Pie Chart (Monthly)
  output$mood_monthly_pie <- renderPlot({
    monthly_data <- data %>% filter(format(date, "%Y-%m") == input$mood_month)
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
  
  # Activity Display
  output$activity_display <- renderUI({
    activity_data <- data %>% filter(date == input$activity_date)
    if (nrow(activity_data) == 0) return("No data available")
    activity <- activity_data$active[1]
    icon_name <- ifelse(activity == "Active", "running", "x")
    tagList(icon(icon_name), strong(activity))
  })
  
  # Activity Pie Chart (Monthly)
  output$activity_monthly_pie <- renderPlot({
    monthly_data <- data %>% filter(format(date, "%Y-%m") == input$activity_month)
    ggplot(monthly_data, aes(x = "", fill = active)) +
      geom_bar(width = 1, stat = "count") +
      coord_polar("y") +
      labs(title = paste("Activity Distribution in", input$activity_month), fill = "Activity") +
      theme_void()
  })
  
  # Full Data Table
  output$full_data_table <- renderDT({
    datatable(data)  # Display the entire data in a table format
  })
}

# Run the application
shinyApp(ui = ui, server = server)
