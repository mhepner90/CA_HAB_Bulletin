
#example code https://cfss.uchicago.edu/notes/shiny/
#rm(list=ls()) 

# 1. Load Libraries 
library(shiny)
library(shinythemes)
library(tidyverse)
library(ggplot2)
library(rsconnect)
library(scales)
library(lubridate)
#install.packages('rsconnect')
#rsconnect::setAccountInfo(name='sccoos', token='46A35F225508EFAB929987BC33C4E3AE', secret='pa1zqctDeVWPoaT6zjsE4Y+dw1u9D1yK/VMNjThM') 

#2. Load Data 
githubURL = ("https://raw.github.com/mhepner90/CA_HAB_Bulletin/master/HABMAP_Data/HAB_data_long.rds")
download.file(githubURL, "HAB_data_long.rds")
HAB_data_long = readRDS("HAB_data_long.rds")

#source_data("https://github.com/mhepner90/CA_HAB_Bulletin/blob/master/HABMAP_Data/HAB_data_long.rds?raw=true")
#HAB_data_long = read_rds("HABMAP_Data/HAB_data_long.rds")
#HAB_data_long = write_rds(HAB_data_long, "HABMAP_Data/HAB_data_long.rds")
#HAB_data_long = read_csv("HABMAP_Data/HAB_data_long.csv") 
# Parsed with column specification:
#     cols(
#         Location = col_character(),
#         Date = col_date(format = ""),
#         Observations = col_character(),
#         measurement = col_double()

#Listening on http://127.0.0.1:6181

#3. Define UI{} User Interface for Application 
ui = fluidPage(
    theme = shinytheme("cerulean"), #changes theme style to blue 
    titlePanel("California HAB Monitoring",
               windowTitle = "SCCOOS"),     # Application title
    sidebarLayout(
        sidebarPanel( #Inputs: Select variables to plot 
            selectInput(inputId = "Location", 
                        label = h3("Sampling Location"), 
                        choices =c("Newport Pier"="NP",
                                    "Stearns Wharf"="SW",
                                    "Cal Poly Pier"="CPP",
                                    "Santa Cruz Municipal Wharf"="HAB_SCW"), # "Monterey Wharf", # "Santa Monica Pier",
                        #choices=sort(unique(HAB_data_long$Location)),
                        #selected ="Cal Poly Pier",
                        multiple = F),
            selectInput(inputId="Observations",
                        label=h3("HAB Species"),
                        #choices = sort(unique(HAB_data_long$Observations)),
                        choices=c("Domoic Acid" = "pDA", 
                                   "Alexandrium spp." = "Alex",
                                   "Pseudo-nitzschia delicatissima group" = "PN_deli",
                                   "Pseudo-nitzschia seriata group" = "PN_seri"),   
                        #c("Akashiwo sanguinea",
                        #   "Ceratium spp.",
                        #   "Cochlodinium spp.",
                        #   "Dinophysis spp.",
                        #   "Gymnodinium spp.",
                        #   "Prorocentrum spp.",
                         selected = "Domoic Acid",
                        multiple = F),
            #sliderInput("Date", "Date Range", 2008, 2019, value= c(2008,2019), sep=""),
            dateRangeInput(inputId="Date", 
                            label=h3("Date Range"), 
                            start=min(HAB_data_long$Date),
                            end= max(HAB_data_long$Date))
            #dateRangeInput(inputId="Date", 
            #               label= h3("Date Range"), 
            #               start= Sys.Date() -14, end=Sys.Date()+2,
            #               format="dd/mm/yyyy")
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("HABplot"))
    )
)

#4. Define server logic required to draw the plots 
#server = function(input, output) {

server = shinyServer(function(input, output) {
    
    output$HABplot <- renderPlot({ 
        
        Observations=input$Observations
        startDate=as.Date(input$Date[1])
        endDate=as.Date(input$Date[2])
        
        filtered_data=HAB_data_long %>% 
            filter(
                Location == input$Location,
                Observations == input$Observations,
                Date>=startDate & Date<=endDate)
        
        ggplot(data=filtered_data, aes(x=Date, y=measurement, group=Observations))+ 
            geom_point(aes(color=Observations),lwd = 1)+
            geom_line(aes(color=Observations),lwd = 1)+
            scale_x_date(date_breaks = "1 month", 
                         labels=date_format("%b-%Y"),
                         limits = as.Date(c(startDate,endDate)))+
            labs(x = "Date Range", y = "Cells/L")+
            theme_bw()+
            theme(axis.text.x = element_text(angle = 45, hjust = 1),
                  panel.grid.major=element_blank(),
                  panel.grid.minor=element_blank(),
                  legend.position="none",
                  axis.title.x=element_text(size=12),
                  axis.title.y=element_text(size=12),
                  title=element_text(size=12))
    })
})
    
    # output$dateRangeText = renderText({
    #     paste("input$Date is", 
    #           paste(as.character(input$Date), collapse = " to "))
    # })
    #actionButton(inputId = "write_csv", label = "Write CSV")    
#})

#5. Run the application 
shinyApp(ui = ui, server = server)

#deployApp("California_HAB")

#https://sccoos.shinyapps.io/california_hab/
