#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#    http://shiny.rstudio.com/
# Helpful tags https://shiny.rstudio.com/articles/tag-glossary.html
# Learning shiny dataset http://juliawrobel.com/tutorials/shiny_tutorial_nba.html example dataset load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

library(shiny)

# Define UI for application that draws a histogram
ui = (fluidPage( #shinyUI

    # Application title
    titlePanel("HAB Monitoring"),

    # Sidebar layout with a input and output definitions with a slider input for number of bins
    sidebarLayout(
        #Inputs: Select variables to plot 
        sidebarPanel(
            #Select variables 
            selectInput(inputId = "location", 
                        label = "Sampling Location", 
                        choices =c("Newport Pier"="NP",
                                   "Stearns Wharf"="SW",
                                   "Cal Poly Pier"="CPP",
                                   "Santa Cruz Municipal Wharf"="HAB_SCW")),
                        #multiple = T)),
                        #selected ="Cal Poly Pier"), 
                        #choices = levels(HAB_data$Location),
                        #selected =levels(HAB_data$Location),
                        #names(HAB_data)[[1]]),
                        #choices=c("Newport Pier","Stearns Wharf","Cal Poly Pier","Santa Cruz Municipal Wharf")), #"Scripps Pier","Monterey Wharf", "Santa Monica Pier",
            #Select variables for y-axis 
            selectInput(inputId="observations",
                        label="HAB Species", 
                        choices=c("Domoic Acid" = "pDA", 
                                  "Alexandrium spp." = "Alex",
                                  "Pseudo-nitzschia delicatissima group" = "PN_deli",
                                  "Pseudo-nitzschia seriata group" = "PN_seri")),
                        #choices = levels(HAB_data$Observations),
                        #selected = levels(HAB_data$Observations)),
                        #selected = "Domoic Acid"),
                        #names(HAB_data)[[3]]),
                        #choices= c("Domoic Acid", "Alexandrium spp.","Pseudo-nitzschia delicatissima group","Pseudo-nitzschia seriata group")), 
            #"Akashiwo sanguinea","Ceratium spp.","Cochlodinium spp.","Dinophysis spp.","Gymnodinium spp.","Prorocentrum spp.",
            sliderInput(inputId="date", 
                        label="Date Range", min=2008, max=2019, value= c(2008,2019), sep="")),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput(outputId="HABplot", width=10, height=7)
        )
    )
)
)
