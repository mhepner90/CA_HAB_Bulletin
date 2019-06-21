
#example code https://cfss.uchicago.edu/notes/shiny/
#rm(list=ls()) 

# 1. Load Libraries 
library(shiny)
library(tidyverse)
library(ggplot2)
library(rsconnect)
#install.packages('rsconnect')
#rsconnect::setAccountInfo(name='sccoos', token='46A35F225508EFAB929987BC33C4E3AE', secret='pa1zqctDeVWPoaT6zjsE4Y+dw1u9D1yK/VMNjThM') 

#2. Load Data 
HAB_data_long = read_csv("~/Google Drive File Stream/My Drive/SCCOOS/CA_HAB_Bulletin/HAB_data_long.csv")
#print(glimpse(HAB_data_long))

#Listening on http://127.0.0.1:6181

#3. Define UI{} User Interface for Application 
ui = fluidPage(
    titlePanel("California HAB Monitoring"),     # Application title
    sidebarLayout(
        sidebarPanel( #Inputs: Select variables to plot 
            selectInput(inputId = "Location", 
                        label = "Sampling Location", 
                        # choices =c("Newport Pier"="NP",
                        #            "Stearns Wharf"="SW",
                        #            "Cal Poly Pier"="CPP",
                        #            "Santa Cruz Municipal Wharf"="HAB_SCW"),
                        choices=sort(unique(HAB_data_long$Location)),
                        #selected ="Cal Poly Pier",
                        multiple = F),
            selectInput(inputId="Observations",
                        label="HAB Species",
                        choices = sort(unique(HAB_data_long$Observations)),
                        #choices=c("Domoic Acid" = "pDA", 
                        #           "Alexandrium spp." = "Alex",
                        #           "Pseudo-nitzschia delicatissima group" = "PN_deli",
                        #           "Pseudo-nitzschia seriata group" = "PN_seri"),
                        # selected = "Domoic Acid",
                        multiple = F),
            #sliderInput("Date", "Date Range", 2008, 2019, value= c(2008,2019), sep=""),
            dateRangeInput(inputId="Date", 
                           label="Date Range", 
                           start=min(HAB_data_long$Date),
                           end= max(HAB_data_long$Date))
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("HABplot"))
    )
)

#4. Define server logic required to draw the plots 
#server = function(input, output) {

server = shinyServer(function(input, output) {    
    
    #reactive expressions 
    # filtered_data = reactive({
    #     HAB_data_long = 
    #         filter(Location == input$Location,
    #                Observations == input$Observations)
    #     })
    # 
    output$HABplot <- renderPlot({
    
    HAB_data_long %>%
        filter(Location == input$Location,
               Observations == input$Observations)
    
    #output$HABplot <- renderPlot({  
        ggplot(HAB_data_long, aes(x=Date, y=measurement))+ #input$Date
            geom_point(aes(color=Observations))+
            geom_line(aes(color=Observations))+
            labs(x = "Date Range", y = "Cells/L")
    })
})


#code below kind of works
# server = shinyServer(function(input, output) {    
# 
#     output$HABplot <- renderPlot({
#         HAB_data_long %>%
#             filter(Location == input$Location,
#                    Observations == input$Observations)
#         ggplot(HAB_data_long, aes(x=Date, y=measurement))+ #input$Date
#             geom_point(aes(color=Observations))+
#             geom_line(aes(color=Observations))+
#             labs(x = "Date Range", y = "Cells/L")
#     })
# })


#5. Run the application 
shinyApp(ui = ui, server = server)

#deployApp("California_HAB")
#https://sccoos.shinyapps.io/california_hab/
