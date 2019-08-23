#TMMC Suspected DA Toxicosis Strandings

# 1. Load Libraries 
library(shiny)
library(shinythemes)
library(tidyverse)
library(dygraphs) #dygraphs
library(xts)

#2. Load Data
#TMMC_data = read.csv('/Volumes/GoogleDrive/My Drive/SCCOOS/CA_HAB_Bulletin/Stranding_Data/Data/1998-2019_TMMC_DA.csv')
TMMC_data = read_rds('TMMC Dygraph/TMMC_Data.rds')

#3. Define UI{} User Interface for Application 
ui <- fluidPage(
    theme = shinytheme("cerulean"), #changes theme style to blue 
    # Application title
    titlePanel("The Marine Mammal Marine Center Suspected Strandings due to Domoic Acid"),
    # sidebarLayout(
    #     sidebarPanel( #Inputs: Select variables to plot 
    #         selectInput(inputId = "Varobles", 
    #                     label = h3("Variables"), 
    #                     choices =c("Common Name"="Common_Name",
    #                                "Age Class"="Age_Class",
    #                                "Sex"="Sex",  
    #                                "Stranding County"="Stranding_County",
    #                                "Stranding City"="Stranding_City"), 
    #                     selected ="Common_Name",
    #                     multiple = F),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        dygraph(data=don3, main = "TMMC California Sea Lion Strandings Suspected DA", xlab = "", ylab= "Sea Lion Strandings Due to Suspected DA") %>%
            dyOptions(labelsUTC = TRUE, fillGraph=TRUE, fillAlpha=0.4, drawGrid = T, drawPoints = T) %>% #colors="#D8AE5A"
            dyRangeSelector() %>%
            dyAxis("x", valueRange = c(1998, 2019))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

#deployApp("TMMC_Dygraph")
#deployApp(appDir = getwd(), appName = "TMMC_Dygraph")
#rsconnect::showLogs("TMMC_Dygraph")

#https://sccoos.shinyapps.io/TMMC_Dygraph/