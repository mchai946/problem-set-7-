
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)
library(readr)
library(dplyr)
library(base)
library(janitor)
library(extrafont)

#Reading in the data
my_data <- read_rds("my_data.rds")

#Assigning variable names to options in the drop-down menu
options <- c("Poll Prediction Error" = "p_error", 
             "Senate Democrat" = "sen_dem", 
             "Senate Republican" = "sen_rep", 
             "Trump Approval Rating" = "approve")

# Define UI for application that draws a scatterplot
ui <- fluidPage(
  
  # Application title
  titlePanel("Polls Results from States with Key Senate Races"),
  
  # Sidebar   
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "y", #internal label
                  label = "Choose your variable:",
                  choices = c(options),
                  selected = "Poll Prediction Error")),
    
    
    # Show titles and other headers
    mainPanel(
      h3("2018 Midterms"),
      p("Before the election, the New York Times identified several Senate races as too close to call. Here are the results from their polls."),
      em("Click on the dots in the legend to display results by party"),
      plotlyOutput("distplot"),
      h3("Summary of Findings:"),
      p("1. The poll prediction error graph measures the final Republican advantage minus the New York Times Upshot / Siena College poll predictions of Republican advantage. There were relatively low margins of error, with the largest errors in Nevada (-7.0%) and Texas (-5.5%)."),
      br(),
      p("2. The Senate Democrat graph demonstrates the percentage of poll respondents that were in favor of a majority Democratic Senate. Interestingly, in Nevada, approximately 35% of poll respondents said they were in favor of a majority Democratic Senate. This shows the inaccuracy the polling and taking a small sample size can sometimes have.  This means that their proportion of Republican-supporting respondents were potentially greater than the actual voting population. Voter turnout? What went wrong?"),
      br(),
      p("3. The Senate Republican graph demonstrates the percentage of poll respondents that were in favor of a majority Republican Senate. Poll results from Texas and Tennessee showed that majority of poll respondents would be in support of a majority-Republican Senate; the poll predictions were correct."),
      br(),
      p("4. When asked the question, “Do you approve or disapprove of the job Donald Trump is doing as president?” the responses were predominantly around the 50% approval range, with an outlier in Tennessee above 60%. Interestingly, Florida had the lowest approval rating of Trump but went Republican to Rick Scott in the Senate race (although votes went to a recount). In Nevada and Arizona, Democrats flipped the Senate seat, despite not having strong disapproval ratings of Trump."))))


# Define server logic required to draw a scatterplot
server <- function(input, output, session) {
  
  output$distplot <- renderPlotly({
    ggplotly(ggplot(data = my_data,
                    aes_string(y = input$y, x = "state")) + 
               geom_point(stat = "identity", aes(fill = win_party), size = 3) + 
               labs(x = "Senate Race", y = input$y) +
               theme(axis.text.x = element_text(hjust = 1)) +
               scale_fill_manual(name = "Winning Party", values = c("#2985c4", "#cf222b")) + 
               theme_minimal() +
               theme(text=element_text(family="Times New Roman", face="bold", size=12)))}) 

}

# Run the application 
shinyApp(ui = ui, server = server)

