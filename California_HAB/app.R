#
# Find out more about building applications with Shiny here: http://shiny.rstudio.com/

#rm(list=ls()) 
library(shiny)
library(tidyverse)
library(ggplot2)
#install.packages('rsconnect')
#rsconnect::setAccountInfo(name='sccoos', token='46A35F225508EFAB929987BC33C4E3AE', secret='pa1zqctDeVWPoaT6zjsE4Y+dw1u9D1yK/VMNjThM') 
HAB_data_long = read_csv("~/Google Drive File Stream/My Drive/SCCOOS/CA_HAB_Bulletin/HAB_data_long.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("HAB Monitoring"),     # Application title
    sidebarLayout(
        sidebarPanel( #Inputs: Select variables to plot 
            selectInput(inputId = "Location", 
                        label = "Sampling Location", 
                        # choices =c("Newport Pier"="NP",
                        #             "Stearns Wharf"="SW",
                        #             "Cal Poly Pier"="CPP",
                        #             "Santa Cruz Municipal Wharf"="HAB_SCW"),
                        choices=sort(unique(HAB_data_long$Location)),
                        #selected ="Cal Poly Pier",
                        multiple = T),
            selectInput(inputId="Observations",
                        label="HAB Species",
                        choices = sort(unique(HAB_data_long$Observations)),
                        #choices=c("Domoic Acid" = "pDA", 
                        #           "Alexandrium spp." = "Alex",
                        #           "Pseudo-nitzschia delicatissima group" = "PN_deli",
                        #           "Pseudo-nitzschia seriata group" = "PN_seri"),
                        # selected = "Domoic Acid",
                         multiple = T),
            dateRangeInput(inputId="Date", 
                           label="Date Range", 
                           start=min(HAB_data_long$Date),
                           end= max(HAB_data_long$Date))
        ),
                        #min=2008, max=2019, value= c(2008,2019), sep="")),
        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("HABplot"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$HABplot <- renderPlot({
        #HAB_data_long %>%
        #    filter(Location %in% input$Location,
        #           Observations %in% input$Observations)
        
        HAB_data_long %>%
            filter(Location == input$Location,
                   Observations == input$Observations)
        
        ggplot(data=HAB_data_long, aes(x=Date, y=measurement))+ #input$Date
            geom_point(aes(color=Observations))+
            geom_line(aes(color=Observations))+
            labs(x = "Date Range", y = "Cells/L")
    })
}
    
    #output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
     #   x    <- faithful[, 2]
      #  bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
       # hist(x, breaks = bins, col = 'darkgray', border = 'white')
  #  })
#}

# Run the application 
shinyApp(ui = ui, server = server)

#library(rsconnect)
#deployApp()

