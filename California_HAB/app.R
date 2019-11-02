#rm(list=ls()) 

# 1. Load Libraries 
library(shiny)
library(shinythemes)
library(tidyverse)
library(ggplot2)
library(rsconnect)
library(scales)
library(lubridate)
#library(data.table)
library(DT)
#https://shiny.rstudio.com/gallery/

#install.packages('rsconnect')
#rsconnect::setAccountInfo(name='sccoos', token='46A35F225508EFAB929987BC33C4E3AE', secret='pa1zqctDeVWPoaT6zjsE4Y+dw1u9D1yK/VMNjThM') 

#2. Load Data 
#githubURL = ("https://raw.github.com/mhepner90/CA_HAB_Bulletin/master/HABMAP_Data/HABMAP_Data_Long_Units.rds")
#download.file(githubURL, "HABMAP_Data_Long_Units.rds")

#setwd("/Users/mhepner/Documents/GitHub/CA_HAB_Bulletin/California_HAB")
HABMAP_Data = read_rds("HABMAP_Data_Long_Units.rds") 
#HABMAP_Data = read_rds("HABMAP_Data.rds") 
#print(HABMAP_Data)

#3. Define UI{} User Interface for Application 
ui = fluidPage(
    theme = shinytheme("cerulean"), #changes theme style to blue 
    titlePanel("California HABMAP Monitoring",
               windowTitle = "SCCOOS"),     # Application title
    sidebarLayout(
        sidebarPanel( #Inputs: Select variables to plot 
            selectInput(inputId = "Location_Code", 
                        label = h3("Sampling Location"), 
                        choices =c(#"Scripps Pier"="SP",
                                   "Newport Pier"="NP", #NP 
                                   "Santa Monica Pier"="SMP",
                                   "Stearns Wharf"="SW",
                                   "Cal Poly Pier"="CPP",
                                   "Monterey Wharf"= "HAB_MWII", #"MW", #"HAB_MWII"
                                   "Santa Cruz Municipal Wharf"= "HAB_SCW" #"HAB_SCW"
                        ), 
                        selected ="CPP",
                        multiple = F),
            selectInput(inputId="Observations",
                        label=h3("Observations"),
                        #choices = sort(unique(HAB_data_long$Observations)),
                        choices=c(
                            "Domoic Acid (ng/mL)" = "pDA", 
                            "Pseudo-nitzschia delicatissima group (cells/L)" = "Pseudo_nitzschia_delicatissima_group",
                            "Pseudo-nitzschia seriata group (cells/L)" = "Pseudo_nitzschia_seriata_group",
                            "Alexandrium spp. (cells/L)" = "Alexandrium_spp",
                            "Akashiwo sanguinea (cells/L)" = "Akashiwo_sanguinea",
                            "Ceratium spp. (cells/L)" = "Ceratium",
                            "Cochlodinium spp. (cells/L)"= "Cochlodinium",   
                            "Dinophysis spp. (cells/L)"="Dinophysis_spp",
                            "Gymnodinium spp. (cells/L)"= "Gymnodinium_spp",
                            "Lingulodinium polyedra (cells/L)"="Lingulodinium_polyedra",
                            "Prorocentrum spp. (cells/L)" = "Prorocentrum_spp",
                            "Average Chlorophyll-a (mg/m3)"= "Avg_Chloro",    
                            "Average Phaeo-pigments (mg/m3)"= "Avg_Phaeo",
                            "Ammonium (μm)"= "Ammonium",
                            "Nitrate (μm)"= "Nitrate",
                            "Phosphate (μm)"= "Phosphate",                           
                            "Silicic Acid (μm)"= "Silicate",
                            "Temperature (°C)"= "Temp"),  
                        selected = "Alexandrium_spp",
                        multiple = F),
            #sliderInput("Date", "Date Range", 2008, 2019, value= c(2008,2019), sep=""),
            dateRangeInput(inputId="Date", 
                           label=h3("Date Range"), 
                           start = Sys.Date() - 365, 
                           end = Sys.Date())
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                type = "tabs",
                tabPanel("Plot", plotOutput("HABplot")),
                tabPanel("Table", dataTableOutput("HABtable")) 
            )
        )
    )
)

#4. Define server logic required to draw the plots 

server = shinyServer(function(input, output) {
    
    output$HABplot <- renderPlot({ 
        
        Observations=input$Observations
        startDate=as.Date(input$Date[1])
        endDate=as.Date(input$Date[2])
        
        filtered_data=HABMAP_Data %>% 
            filter(
                Location_Code == input$Location_Code, #Location
                Observations == input$Observations,
                Date>=startDate & Date<=endDate)
        
        ggplot(data=filtered_data, aes(x=Date, y=Measurement, group=Observations))+ 
            geom_point(aes(color=Observations),lwd = 3)+
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
    
    output$HABtable = renderDataTable({
        
        Observations=input$Observations
        startDate=as.Date(input$Date[1])
        endDate=as.Date(input$Date[2])
        
        filtered_data=HABMAP_Data %>% 
            filter(
                Location_Code == input$Location_Code, 
                Observations == input$Observations,
                Date>=startDate & Date<=endDate)
        
        DT::datatable(filtered_data,
                      options = list(pageLength=15, searching= FALSE))
    })
})

#5. Run the application 
shinyApp(ui = ui, server = server)

#deployApp("California_HAB")
#deployApp(appDir = getwd(), appName = "california_hab")
#rsconnect::showLogs("California_HAB")

#https://sccoos.shinyapps.io/california_hab/
