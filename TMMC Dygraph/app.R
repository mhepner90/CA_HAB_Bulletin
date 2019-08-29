# #TMMC Suspected DA Toxicosis Strandings
# 
# # 1. Load Libraries 
library(shiny)
library(shinythemes)
library(tidyverse)
library(dygraphs)
library(xts)
 
#2. Load Data
#TMMC_data = read.csv('/Volumes/GoogleDrive/My Drive/SCCOOS/CA_HAB_Bulletin/Stranding_Data/Data/1998-2019_TMMC_DA.csv')
#TMMC_data = read_rds('TMMC Dygraph/TMMC_Data.rds')
TMMC_data = read_rds('TMMC_Data.rds')

#3. Define UI{} User Interface for Application 
ui <- fluidPage(
     theme = shinytheme("cerulean"), #changes theme style to blue 
     # Application title
     titlePanel("The Marine Mammal Marine Center (TMMC) Suspected Strandings due to Domoic Acid"),
     # Show a plot of the generated distribution
     #mainPanel(
         dygraphOutput("plot")
         #plotOutput("distPlot")
     #)
)
         
# Define server logic required to draw a histogram
server <- function(input, output) {
    
     test2 = TMMC_data %>%
         select(Strand_Date,Common_Name,Stranding_County) %>%
         filter(Common_Name == 'California Sea Lion')%>% 
         mutate(Year_Month = format(as.Date(Strand_Date),"%Y-%m")) %>%
         group_by(Year_Month)%>%
         summarize(Strandings=length(Year_Month))
     
     test2$Year_Month = as.yearmon(test2$Year_Month, "%Y-%m")
     don3 = xts(x=test2$Strandings, order.by = test2$Year_Month)
 
     output$plot <- renderDygraph({ #renderPlot
         dygraph(data=don3, xlab = "", ylab= "Number of California Sea Lion Strandings") %>% #main = "TMMC California Sea Lion \nStrandings due to Suspected DA",
             dyOptions(labelsUTC = TRUE, fillGraph=TRUE, fillAlpha=0.4, drawGrid = T, drawPoints = T) %>% 
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
