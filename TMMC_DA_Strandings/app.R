#

# 1. Load Libraries 
library(shiny)
library(shinythemes)
library(tidyverse)
library(dygraphs) #dygraphs
library(xts)

#2. Load Data
TMMC_data = read.csv('/Volumes/GoogleDrive/My Drive/SCCOOS/CA_HAB_Bulletin/Stranding_Data/Data/1998-2019_TMMC_DA.csv')

#3. Define UI{} User Interface for Application 
ui <- fluidPage(
    theme = shinytheme("cerulean"), #changes theme style to blue 
    # Application title
    titlePanel("The Marine Mammal Marine Center Suspected Strandings due to Domoic Acid"),
    sidebarLayout(
        sidebarPanel( #Inputs: Select variables to plot 
            selectInput(inputId = "Varobles", 
                        label = h3("Variables"), 
                        choices =c("Common Name"="Common_Name",
                                   "Age Class"="Age_Class",
                                   "Sex"="Sex",  
                                   "Stranding County"="Stranding_County",
                                   "Stranding City"="Stranding_City"), 
                        selected ="Common_Name",
                        multiple = F),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
