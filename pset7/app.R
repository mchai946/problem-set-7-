
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

my_data <- read_rds("xyz.rds")
options <- c("Prediction Error" = "p_error", "Senate Democrat" = "sen_dem", "Senate Republican" = "sen_rep", "Trump Approval" = "approve", "SENC Democrat" = "SENC_Dem")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("2018 Midterms: Key Senate Races"),
  
  # Sidebar  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "y", #internal label
                  label = "Choose data to see",
                  choices = c(options),
                  selected = "Prediction Error")),
    
    
    # Show a plot of the generated distribution
    mainPanel(h5("Before the election, the New York Times identified several Senate races as too close to call. Here are the results from their polls."),
              plotlyOutput("distplot"))))


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distplot <- renderPlotly({
    ggplotly(ggplot(data = my_data,
                    aes_string(y = input$y, x = "state")) + 
               geom_point(stat = "identity", aes(fill = win_party), size = 3) + 
               labs(x = "Senate Race", y = input$y) +
               theme(axis.text.x = element_text(hjust = 1)) +
               scale_fill_manual(values = c("#2985c4", "#cf222b")))}) 
}


# Run the application 
shinyApp(ui = ui, server = server)

