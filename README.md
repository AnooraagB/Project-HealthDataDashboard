# Health Data Dashboard
 
This project involves developing an interactive **Health Data Dashboard** using R, RShiny, and SQLite. The dashboard visualises various health metrics like steps, mood, calories burned, sleep hours, and activity levels, based on Fitbit health data.

It is aimed towards helping the user take an informed approach to their health and lifestyle choices, helping improve **Health Literacy**.

## Video Demonstration

https://github.com/user-attachments/assets/952c6813-c965-40c8-b673-80a0818e68a3

## Features

* **Interactive data visualisations** : The dashboard uses various interactive visualisations to display health data, such as line graphs and pie charts.
* **Data filters** : Users can filter data by date range for a more personalised experience.
* **Multiple health metrics** : Displays metrics such as steps, mood, calories burned, sleep hours, and activity levels.
* **Shiny application** : A fully interactive User Interface (UI) built using RShiny, enabling easy navigation between different health metrics.
* **Visual summary** : Provides a visual summary of key insights of the various health metrics from the data used.
* **Full data table** : Users can view the entire dataset in a table format, making it easy to explore all the data at once.
* **Data export** : Users can export filtered health data into a CSV format.

## Tools and Technologies Used

* **R Programming** : The project is implemented using R for data manipulation and visualisation.
* **RShiny** : Used to create an interactive web dashboard with various tabs and visualisations.
* **SQLite** : An SQLite database is used to store and manage health data efficiently.
* **ggplot2** : Used for plotting line graphs and pie charts for the various health metrics.
* **Shinydashboard** : Used for creating the layout of the dashboard with menus, boxes, and tabs.
* **dplyr** : Used for data manipulation and filtering within the Shiny application.
* **DT** : Used to display the dataset in an interactive table format.
* **DBI** : Used for database interaction to read data from SQLite.

## Dataset used

The data is stored in a tab-delimited file (fit.txt) and then imported into an SQLite database (healthdashboard.db) for efficient querying and manipulation and the dataset used in this project is a Fitbit data file obtained from Kaggle (https://www.kaggle.com/datasets/devarajv88/fitbit-dataset), including various health metrics such as:
1. Steps
2. Mood (Happy, Neutral, Sad)
3. Calories burned
4. Hours of sleep
5. Activity levels (Active or Inactive)

## Concepts used

* **Data Handling with SQLite and R**
  * **SQLite** : The data is imported from a tab-delimited file into an SQLite database. This allows efficient querying of the data for use within the Shiny application.
  * **R data frames** : Data is retrieved from the SQLite database and stored in R data frames for analysis and visualisation.
* **Data visualisation with ggplot2**
  * **Line plots** : Used to display the trend of steps, calories burned, and hours of sleep over time.
  * **Pie charts** : Used to visualise the distribution of mood and activity levels.
* **Shiny UI and server**
  * **UI layout**: The dashboard is organised into tabs, with each tab representing a different health metric.
  * **Reactive data** : The app reacts to user inputs (such as date selection) and dynamically updates visualisations.

## Files

* **healthdashboardRscript.R** <br />
Contains the code for establishing a connection to the SQLite database, performing queries, and managing the health data. This file interacts with the database to fetch and prepare data for use in the dashboard.

* **healthdashboardshinyapp.R** <br />
The main Shiny application file, containing the UI and server logic for the interactive dashboard. It uses the SQLite database to read data, summarise it, generates various plots, and includes the export functionality to download filtered data as CSV.

## Getting started
* **Prerequisites**
  * R (version 4.0 or higher)
  * RStudio (optional, but recommended for development)
  * Required R packages:
    * readr
    * RSQLite
    * DBI
    * shiny
    * ggplot2
    * DT
    * shinydashboard
    * dplyr
  * To install these packages, use the following code :
    ```
    install.packages(c("readr", "RSQLite", "DBI", "shiny", "ggplot2", "DT", "shinydashboard", "dplyr"))
    ```
* **Launch the Shiny application**
  * Clone the repository to your local machine or download the files :
  ```
  git clone https://github.com/AnooraagB/Project-Health-Data-Dashboard.git
  ```
  * Ensure that the input data file (fit.txt) is placed in the same directory as the Shiny application (healthdashboardshinyapp.R) or adjust the file path accordingly in the code.
  * After installing the packages and placing the data file, you can run the Shiny app using the shiny::runApp() function. In the R console, use the following command :
  ```
  shiny::runApp("path/to/your/project")
  ```
  Replace "path/to/your/project" with the actual path where you have cloned the project folder.
  * If you are using RStudio, you can navigate to the directory where the project is located through "Set Working Direcroty" available under "Session".
* **Using the dashboard**
  * Once the app is running, use the sidebar menu to navigate through different tabs such as "Summary," "Steps," "Mood," "Calories," "Sleep," "Activity," "Full Data," "Export", and "About".
  * You can filter data by date range, view various health metrics over time, and export filtered data.
  * The Shiny application will launch in your default web browser. You should see the Health Data Dashboard with all the interactive features ready to use.

## Future plans

* Explore other ways to further improve UI and functionality of the dashboard.
* Make dashboard adaptable to more datasets and data formats.
* Use Artificial Intelligence (AI) and Machine Learning (ML) to provide personalised recommendations.
* Suggestions for improvements and comments on the project are much appreciated.

### ________________
### by Anooraag Basu
