#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
#install.packages('rsconnect')
#rsconnect::setAccountInfo(name='sccoos', token='46A35F225508EFAB929987BC33C4E3AE', secret='pa1zqctDeVWPoaT6zjsE4Y+dw1u9D1yK/VMNjThM') 
#library(rsconnect)
#HAB_data = read_csv("~/Volumes/GoogleDrive/My Drive/SCCOOS/CA_HAB_Bulletin/HAB_data.csv")
HAB_data_long = read_csv("~/Google Drive File Stream/My Drive/SCCOOS/CA_HAB_Bulletin/HAB_data_long.csv")


# Define server logic required to draw a plot
server = (function(input, output) { #shinyServer

    output$HABplot <- renderPlot({
        
        HAB_data %>%
            filter(Location %in% input$Location,
                   Observations %in% input$Observations)
        
        #HAB_plot = HAB_data %>%
            #filter(Location == input$Location)%>%
            #filter(Observations == input$Observations)
        
        ggplot(data=HAB_data, aes(x=input$Date, y=input$Observations))+
            geom_point()+
            geom_line()+
            labs(x = "Date Range", y = "Cells/L")
    }, height = 400, width = 600)
    
    #obs = reactive(names(which(observations==input$Observations)))
    #output$label = renderText(obs)
    
    #output$dateRangeText  <- renderText({
     #   paste("input$dateRange is", 
     #         paste(as.character(input$dateRange), collapse = " to ")
     #   )})
        
})

shinyApp(ui = ui, server = server)
#rsconnect::deployApp("<path to directory>")

#deployApp()