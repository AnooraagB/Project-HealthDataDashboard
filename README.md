# Health Data Dashboard
 
This project involves developing an interactive **Health Data Dashboard** using R, RShiny, and SQLite. The dashboard visualises various health metrics like steps, mood, calories burned, sleep hours, and activity levels, based on Fitbit data.

## Features

* **Interactive data visualisations** : The dashboard uses various interactive visualizations to display health data, such as line graphs and pie charts.
* **Data filters** : Users can filter data by date range for a more personalized experience.
* **Multiple health metrics** : Displays metrics such as steps, mood, calories burned, sleep hours, and activity levels.
* **Shiny application** : A fully interactive User Interface (UI) built using RShiny, enabling easy navigation between different health metrics.
* **Full data table** : Users can view the entire dataset in a table format, making it easy to explore all the data at once.

## Tools and Technologies Used

* **R Programming** : The project is implemented using R for data manipulation and visualization.
* **RShiny** : Used to create an interactive web dashboard with various tabs and visualizations.
* **SQLite** : An SQLite database is used to store and manage health data efficiently.
* **ggplot2** : Used for plotting line graphs and pie charts for the various health metrics.
* **Shinydashboard** : Used for creating the layout of the dashboard with menus, boxes, and tabs.
* **dplyr** : Used for data manipulation and filtering within the Shiny application.
* **lubridate** : Used for handling and formatting date-related data.
* **DT** : Used to display the dataset in an interactive table format.

## Dataset used

The data is stored in a tab-delimited file (fit.txt) and then imported into an SQLite database (healthdashboard.db) for efficient querying and manipulation and the dataset used in this project is a Fitbit data file obtained from Kaggle (https://www.kaggle.com/datasets/devarajv88/fitbit-dataset), including various health metrics such as:
1. Steps
2. Mood
3. Calories burned
4. Hours of sleep
5. Activity levels

## Concepts used

* **Data Handling with SQLite and R**
  * **SQLite** : The data is imported from a tab-delimited file into an SQLite database. This allows efficient querying of the data for use within the Shiny application.
  * **R data frames** : Data is retrieved from the SQLite database and stored in R data frames for analysis and visualization.
* **Data visualisation with ggplot2**
  * **Line plots** : Used to display the trend of steps, calories burned, and hours of sleep over time.
  * **Pie charts** : Used to visualise the distribution of mood and activity levels.
* **Shiny UI and server**
  * **UI layout**: The dashboard is organised into tabs, with each tab representing a different health metric.
  * **Date range filters** : Users can select date ranges or specific dates to view data for a selected period.
  * **Reactive data** : The app reacts to user inputs (such as date selection) and dynamically updates visualisations.
  * **Full data table** : A new tab to display the complete Fitbit dataset in an interactive table format.

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
    * shinyWidgets
    * lubridate
    * dplyr
  * To install these packages, use the following code :
    ```
    install.packages(c("readr", "RSQLite", "DBI", "shiny", "ggplot2", "DT", "shinydashboard", "shinyWidgets", "lubridate", "dplyr"))
    ```
* **Running the dashboard**
  * Clone the repository to your local machine.
  * Place the fit.txt data file in the project directory.
  * Run the following code to launch the Shiny application :
  ```
  shiny::runApp("path/to/your/project")
  ```

## Future plans

* Explore other ways to further improve UI and functionality of the dashboard.
* Make dashboard adaptable to more datasets and data formats.
* Use Artificial Intelligence (AI) and Machine Learning (ML) to provide personalised recommendations.
* Suggestions for improvements and comments on the project are much appreciated.

### ________________
### by Anooraag Basu
