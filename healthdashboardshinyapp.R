library(shiny)
library(ggplot2)
library(DT)
library(shinydashboard)
library(RSQLite)
library(DBI)
library(dplyr)

# SQLite database connection
con <- dbConnect(RSQLite::SQLite(), "healthdashboard.db")

# Read data from SQLite database
data <- dbGetQuery(con, "SELECT * FROM fit_data")

# Convert the date column properly
data$date <- as.character(data$date)
data$date <- as.Date(data$date, format="%d-%m-%Y")

# Get min and max dates
min_date <- min(data$date, na.rm = TRUE)
max_date <- max(data$date, na.rm = TRUE)

# Close the database connection
dbDisconnect(con)

# User Interface (UI)
ui <- dashboardPage(
  dashboardHeader(title = "Health Data Dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Summary", tabName = "summary", icon = icon("chart-bar")),
      menuItem("Steps", tabName = "steps", icon = icon("shoe-prints")),
      menuItem("Mood", tabName = "mood", icon = icon("smile")),
      menuItem("Calories", tabName = "calories", icon = icon("fire")),
      menuItem("Hours of sleep", tabName = "sleep", icon = icon("bed")),
      menuItem("Activity", tabName = "activity", icon = icon("running")),
      menuItem("Full data", tabName = "full_data", icon = icon("database")),
      menuItem("Export", tabName = "export", icon = icon("download")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Home tab
      tabItem(tabName = "home",
              fluidRow(
                box(title = strong("WELCOME TO THE HEALTH DATA DASHBOARD"), width = 12, status = "primary",
                    p("Digital Skills Specialists Edinburgh Award Project"),
                    p("by ", strong("Anooraag Basu")),
                    p(tags$br(), strong("HOW TO USE:")),
                    p("1. Use the menu on the left to navigate between different data views."),
                    p("2. Select the desired date range or specific date to filter the data."),
                    p("3. Visualisations will be updated dynamically based on your selections.")
                )
              )
      ),
      # Summary tab
      tabItem(tabName = "summary",
              fluidRow(
                valueBoxOutput("total_steps"),
                valueBoxOutput("avg_calories"),
                valueBoxOutput("avg_sleep"),
                valueBoxOutput("common_mood"),
                valueBoxOutput("active_days")
              )
      ),
      # Steps tab
      tabItem(tabName = "steps",
              fluidRow(
                box(title = strong("STEPS OVER TIME"), width = 12, status = "primary",
                    dateRangeInput("steps_date", "Select Date Range:",
                                   start = min_date, end = max_date,
                                   min = min_date, max = max_date),
                    plotOutput("steps_plot"))
              )
      ),
      # Mood tab
      tabItem(tabName = "mood",
              fluidRow(
                box(title = strong("MOOD ON SELECTED DATE"), width = 12, status = "primary",
                    dateInput("mood_date", "Select Specific Date:", value = max_date,
                              min = min_date, max = max_date),
                    uiOutput("mood_display")
                )
              ),
              fluidRow(
                box(title = strong("MONTHLY MOOD DISTRIBUTION"), width = 12, status = "primary",
                    selectInput("mood_month", "Select Month & Year:",
                                choices = unique(format(data$date, "%Y-%m")),
                                selected = format(max_date, "%Y-%m")),
                    plotOutput("mood_monthly_pie")
                )
              )
      ),
      # Calories tab
      tabItem(tabName = "calories",
              fluidRow(
                box(title = strong("CALORIES BURNED OVER TIME"), width = 12, status = "primary",
                    dateRangeInput("calories_date", "Select Date Range:",
                                   start = min_date, end = max_date,
                                   min = min_date, max = max_date),
                    plotOutput("calories_plot"))
              )
      ),
      # Hours of sleep tab
      tabItem(tabName = "sleep",
              fluidRow(
                box(title = strong("HOURS OF SLEEP OVER TIME"), width = 12, status = "primary",
                    dateRangeInput("sleep_date", "Select Date Range:",
                                   start = min_date, end = max_date,
                                   min = min_date, max = max_date),
                    plotOutput("sleep_plot"))
              )
      ),
      # Activity tab
      tabItem(tabName = "activity",
              fluidRow(
                box(title = strong("ACTIVITY ON SELECTED DATE"), width = 12, status = "primary",
                    dateInput("activity_date", "Select Specific Date:", value = max_date,
                              min = min_date, max = max_date),
                    uiOutput("activity_display")
                )
              ),
              fluidRow(
                box(title = strong("MONTHLY ACTIVITY DISTRIBUTION"), width = 12, status = "primary",
                    selectInput("activity_month", "Select Month & Year:",
                                choices = unique(format(data$date, "%Y-%m")),
                                selected = format(max_date, "%Y-%m")),
                    plotOutput("activity_monthly_pie")
                )
              )
      ),
      # Full data tab
      tabItem(tabName = "full_data",
              fluidRow(
                box(title = strong("FULL DATA"), width = 12, status = "primary",
                    DTOutput("full_data_table")
                )
              )
      ),
      # Export tab
      tabItem(tabName = "export",
              fluidRow(
                box(title = strong("FILTER AND EXPORT DATA"), width = 12, status = "primary",
                    selectInput("mood_filter", "Filter by Mood:", choices = c("All", unique(data$mood)), selected = "All"),
                    selectInput("activity_filter", "Filter by Activity:", choices = c("All", unique(data$active)), selected = "All"),
                    sliderInput("step_filter", "Filter by Step Count:", min = min(data$step_count), max = max(data$step_count),
                                value = c(min(data$step_count), max(data$step_count))),
                    DTOutput("filtered_data_table")
                ),
                # Download button
                box(title = strong("DOWNLOAD FILTERED DATA"), width = 12, status = "primary",
                    downloadButton("download_data", "Download Filtered Data")
                )
              )
      ),
      # About tab
      tabItem(tabName = "about",
              fluidRow(
                box(title = strong("ABOUT"), width = 12, status = "primary",
                    p(strong("ABOUT ME")),
                    p("Hello, I am Anooraag Basu, a Master of Science in Bioinformatics student at The University of Edinburgh."),
                    p(strong("For more projects visit:  " ), tags$br(), icon("github"), a("Anooraag Basu on GitHub", href="https://github.com/AnooraagB", target="_blank")),
                    p(strong("For more on bioinformatics, student life, and experiences visit:  "), tags$br(), icon("linkedin"), a("Anooraag Basu on LinkedIn", href="https://www.linkedin.com/in/anooraagbasu/", target="_blank")),
                    p(tags$br(), strong("ABOUT THE HEALTH DATA DASHBOARD")),
                    tags$ol(
                      tags$li("This dashboard is designed using R, SQL, and RShiny as part of my Digital Skills Specialists Edinburgh Award project."),
                      tags$li("It aims to enable users to take an informed approach to their health and lifestyle choices, helping promote health literacy."),
                      tags$li("It helps promote a major challenge in today's world : ", strong("Health literacy")),
                      tags$li(strong("According to the National Health Service (NHS)"), ":"),
                      p("Health literacy refers to the personal characteristics and social resources needed for individuals and communities", tags$br(), "to access, understand, appraise, and use information and services to make decisions about health.")
                    ),
                    p(tags$br(), strong("ABOUT THE DIGITAL SKILLS SPECIALISTS EDINBURGH AWARD")),
                    p("It is a self-development programme run by The University of Edinburgh to enhance digital skills."),
                    p(strong("For more information visit:  "), tags$br(), icon("external-link-alt"), a("Digital Skills Specialists Edinburgh Award Website", href="https://information-services.ed.ac.uk/help-consultancy/is-skills/edinburgh-award/digital-skills-specialists", target="_blank"))
                )
              )
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Summary
  output$total_steps <- renderValueBox({
    valueBox(sum(data$step_count, na.rm = TRUE), "Total Steps", icon = icon("shoe-prints"), color = "blue")
  })
  
  output$avg_calories <- renderValueBox({
    valueBox(round(mean(data$calories_burned, na.rm = TRUE), 2), "Avg Calories Burned", icon = icon("fire"), color = "red")
  })
  
  output$avg_sleep <- renderValueBox({
    valueBox(round(mean(data$hours_of_sleep, na.rm = TRUE), 2), "Avg Sleep Hours", icon = icon("bed"), color = "purple")
  })
  
  output$common_mood <- renderValueBox({
    most_common_mood <- names(sort(table(data$mood), decreasing = TRUE))[1]
    valueBox(most_common_mood, "Most Common Mood", icon = icon("smile"), color = "yellow")
  })
  
  output$active_days <- renderValueBox({
    active_percentage <- round(mean(data$active == "Active", na.rm = TRUE) * 100, 2)
    valueBox(paste0(active_percentage, "%"), "Active Days", icon = icon("running"), color = "green")
  })
  
  # Steps
  output$steps_plot <- renderPlot({
    filtered_data <- data %>%
      filter(date >= input$steps_date[1] & date <= input$steps_date[2])
    
    ggplot(filtered_data, aes(x = date, y = step_count)) +
      geom_line(color = "blue") +
      labs(title = "Steps Over Time", x = "Date", y = "Step Count") +
      theme_minimal()
  })
  
  # Mood by specific date
  output$mood_display <- renderUI({
    selected_mood_data <- data %>%
      filter(date == input$mood_date)
    
    if (nrow(selected_mood_data) == 0) {
      return("No data available for this date.")
    } else {
      return(paste("Mood: ", selected_mood_data$mood))
    }
  })
  
  # Mood by month
  output$mood_monthly_pie <- renderPlot({
    selected_month_data <- data %>%
      filter(format(date, "%Y-%m") == input$mood_month)
    
    ggplot(selected_month_data, aes(x = "", fill = mood)) +
      geom_bar(width = 1, show.legend = TRUE) +
      coord_polar(theta = "y") +
      labs(title = "Monthly Mood Distribution", x = NULL, y = NULL) +
      theme_void()
  })
  
  # Calories burned
  output$calories_plot <- renderPlot({
    filtered_data <- data %>%
      filter(date >= input$calories_date[1] & date <= input$calories_date[2])
    
    ggplot(filtered_data, aes(x = date, y = calories_burned)) +
      geom_line(color = "red") +
      labs(title = "Calories Burned Over Time", x = "Date", y = "Calories Burned") +
      theme_minimal()
  })
  
  # Hours of sleep
  output$sleep_plot <- renderPlot({
    filtered_data <- data %>%
      filter(date >= input$sleep_date[1] & date <= input$sleep_date[2])
    
    ggplot(filtered_data, aes(x = date, y = hours_of_sleep)) +
      geom_line(color = "purple") +
      labs(title = "Hours of Sleep Over Time", x = "Date", y = "Hours of Sleep") +
      theme_minimal()
  })
  
  # Activity based on specific date
  output$activity_display <- renderUI({
    activity_data <- data %>% filter(date == input$activity_date)
    if (nrow(activity_data) == 0) return("No data available")
    activity <- activity_data$active[1]
    icon_name <- ifelse(activity == "Active", "running", "x")
    tagList(icon(icon_name), strong(activity))
  })
  
  # Activity based on month
  output$activity_monthly_pie <- renderPlot({
    monthly_data <- data %>% filter(format(date, "%Y-%m") == input$activity_month)
    ggplot(monthly_data, aes(x = "", fill = active)) +
      geom_bar(width = 1, stat = "count") +
      coord_polar("y") +
      labs(title = paste("Activity Distribution in", input$activity_month), fill = "Activity") +
      theme_void()
  })
  
  # Full data table
  output$full_data_table <- renderDT({
    datatable(data, options = list(pageLength = 10))
  })
  
  #Export
  output$filtered_data_table <- renderDT({
    filtered_data <- data
    if (input$mood_filter != "All") {
      filtered_data <- filtered_data %>% filter(mood == input$mood_filter)
    }
    if (input$activity_filter != "All") {
      filtered_data <- filtered_data %>% filter(active == input$activity_filter)
    }
    filtered_data <- filtered_data %>% filter(step_count >= input$step_filter[1] & step_count <= input$step_filter[2])
    # Set rows per page
    datatable(filtered_data, options = list(pageLength = 5))
  })
  
  output$download_data <- downloadHandler(
    filename = function() { "filtered_health_data.csv" },
    content = function(file) {
      filtered_data <- data
      if (input$mood_filter != "All") {
        filtered_data <- filtered_data %>% filter(mood == input$mood_filter)
      }
      if (input$activity_filter != "All") {
        filtered_data <- filtered_data %>% filter(active == input$activity_filter)
      }
      filtered_data <- filtered_data %>% filter(step_count >= input$step_filter[1] & step_count <= input$step_filter[2])
      write.csv(filtered_data, file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
