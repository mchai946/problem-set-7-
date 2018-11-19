
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
my_data <- read_rds("xyz.rds")

#Assigning variable names to options in the drop-down menu
options <- c("Poll Prediction Error" = "p_error", 
             "Senate Democrat" = "sen_dem", 
             "Senate Republican" = "sen_rep", 
             "Trump Approval Rating" = "approve", 
             "SENC Democrat" = "SENC_Dem")

# Define UI for application that draws a scatterplot
ui <- fluidPage(
  
  # Application title
  titlePanel("What do Poll Respondents in States with Key Senate Races Think?"),
  
  # Sidebar   
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "y", #internal label
                  label = "Choose your y-axis",
                  choices = c(options),
                  selected = "Poll Prediction Error")),
    
    
    # Show titles and other headers
    mainPanel(
      h3("2018 Midterms: Key Senate Races"),
      p("Before the election, the New York Times identified several Senate races as too close to call. Here are the results from their polls."),
      em(textOutput("description")),
      plotlyOutput("distplot"))))


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

  #Create reactive expression for displaying text based off of user input.
  output$description <- renderText({ 
    paste("You have selected", input$y, ". Here are the results from NYT poll respondents and", input$y, ".")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

