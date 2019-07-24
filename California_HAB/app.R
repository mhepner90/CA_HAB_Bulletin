
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
#githubURL = ("https://raw.github.com/mhepner90/CA_HAB_Bulletin/master/HABMAP_Data/HABMAP_Data_Long_Units.rds")
#download.file(githubURL, "HABMAP_Data_Long_Units.rds")
#HABMAP_Data = readRDS("HABMAP_Data_Long_Units.rds")

HABMAP_Data = read_csv("HABMAP_Data/HABMAP_data_tes2t.csv")
#unique(HABMAP_Data$Location_Code)
#unique(HABMAP_Data$Observations)

#Listening on http://127.0.0.1:6181

#3. Define UI{} User Interface for Application 
ui = fluidPage(
    theme = shinytheme("cerulean"), #changes theme style to blue 
    titlePanel("California HABMAP Monitoring",
               windowTitle = "SCCOOS"),     # Application title
    sidebarLayout(
        sidebarPanel( #Inputs: Select variables to plot 
            selectInput(inputId = "Location_Code", 
                        label = h3("Sampling Location"), 
                        choices =c("Scripps Pier"="SP",
                                   "Newport Pier"="NBP", #NP 
                                   "Santa Monica Pier"="SMP",
                                   "Stearns Wharf"="SW",
                                   "Cal Poly Pier"="CPP",
                                   "Monterey Wharf"="MW",
                                   "Santa Cruz Municipal Wharf"="HAB_SCW"
                                   ), 
                        selected ="Cal Poly Pier",
                        multiple = F),
            selectInput(inputId="Observations",
                        label=h3("Observations"),
                        #choices = sort(unique(HAB_data_long$Observations)),
                        choices=c(#"Domoic Acid" = "pDA", 
                                   "Pseudo-nitzschia delicatissima group" = "Pseudo_nitzschia_delicatissima_group",
                                   "Pseudo-nitzschia seriata group" = "Pseudo_nitzschia_seriata_group",
                                    "Alexandrium spp." = "Alexandrium_spp",
                                    "Akashiwo sanguinea" = "Akashiwo_sanguinea",
                                    #"Ceratium spp." = "Ceratium",
                                    #"Cochlodinium spp."= "Cochlodinium", 
                                    "Dinophysis spp."="Dinophysis_spp",
                                    #"Gymnodinium spp."= "Gymnodinium_spp",
                                    "Lingulodinium polyedra"="Lingulodinium_polyedra",
                                    "Prorocentrum spp." = "Prorocentrum_spp",
                                    "Ammonium"= "Ammonium",
                                    "Average Chlorophyll-a"= "Avg_Chloro",    
                                    "Average Phaeo-pigments"= "Avg_Phaeo",
                                    "Nitrate"= "Nitrate",
                                    "Phosphate"= "Phosphate",                           
                                    "Silicic Acid"= "Silicate",
                                    "Temperature"= "Temp"),  
                         selected = "Alexandrium spp.",
                        multiple = F),
            #sliderInput("Date", "Date Range", 2008, 2019, value= c(2008,2019), sep=""),
            dateRangeInput(inputId="Date", 
                            label=h3("Date Range"), 
                            start=min(HABMAP_Data$Date),
                            end= max(HABMAP_Data$Date))
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
        
        filtered_data=HABMAP_Data %>% 
            filter(
                Location_Code == input$Location,
                Observations == input$Observations,
                Date>=startDate & Date<=endDate)
        
        ggplot(data=filtered_data, aes(x=Date, y=measurement, group=Observations))+ 
            geom_point(aes(color=Observations),lwd = 1.5)+
            geom_line(aes(color=Observations),lwd = 1.5)+
            scale_x_date(date_breaks = "1 month", 
                         labels=date_format("%b-%Y"),
                         limits = as.Date(c(startDate,endDate)))+
            labs(x = "Date Range", y = "Units")+
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
