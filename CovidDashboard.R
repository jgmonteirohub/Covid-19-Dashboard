library(shiny)
library(tidyverse)
library(shinydashboard)
library(TTR)
library(lubridate)
library(openintro)

states = read.csv("CovidUS.csv")
staes = na.omit(states)
county = read.csv("CovidCounties.csv")
allstates = unique(states$state)
metrics = c("date","positive","positiveIncrease","recovered","death")




ui <- dashboardPage(
    dashboardHeader(title = "COVID-19 Dashboard"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("United States",
                     tabName = "state_tab",
                     icon = icon("dashboard")),
            menuItem("Worldwide",
                     tabName = "country_tab",
                     icon = icon("dashboard")),
            menuItem("Raw Data: United States",
                     tabName = "raw_US",
                     icon = icon("dashboard")),
            menuItem("Raw Data: Worldwide",
                     tabName = "raw_world",
                     icon = icon("dashboard"))
                 
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "state_tab",
                    box(plotOutput("state_timeseries")),
                    box(selectInput(inputId = "statename",
                                    label = "Select the State",
                                    allstates)),
                    box(tableOutput("state_table")))
            
        )
    )
)


server <- function(input, output){
    output$state_table = renderTable({
        data_table = head(states[states$state==input$statename,metrics])
        data_table
    })
    
    output$state_timeseries = renderPlot({
        subset = states[states$state==input$statename,]
        ggplot(subset, aes(x=date,y=positive))+
            geom_line(color="blue")+
            labs(title=paste("Total Positive Cases in",abbr2state(input$statename)),x="Date", y="Total Positive Cases")
            
            
        
    })
    
    
}
# Run the application 
shinyApp(ui = ui, server = server)
