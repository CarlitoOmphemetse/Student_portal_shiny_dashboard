

library(shiny)
library(shinydashboard)
library(remotes)
library(DT)
library(ggplot2)
library(dplyr)

#setwd("C:/Users/omphe/OneDrive/Desktop/studentInfo")

setwd('./')


ui <- dashboardPage(skin='blue',
                    
                    dashboardHeader(title = 'Student Information Portal'),
                    dashboardSidebar(
                        
                        sidebarMenu(
                            
                            menuItem('Data Munging',tabName = 'first'),
                            menuItem('Plots', tabName = 'second'),
                            uiOutput('selector'),
                            uiOutput('radio'),
                            uiOutput('slider')
                        )
                    ),
                    dashboardBody(
                        tabItems(
                            tabItem(tabName = 'first',
                                    h2('Data preparation'),
                                    
                                    fluidRow(
                                        
                                        
                                        DTOutput('dt')
                                        
                                        
                                        
                                        
                                    )),
                            tabItem(tabName = 'second',
                                    h2('Plotting of data'),
                                    
                                    column(width = 6,
                                           plotOutput('histo')),
                                    
                                    column(width = 6,
                                           plotOutput('dense'))
                                    
                            ) 
                        )
                    )
                    
                    
)

server <- function(input,output){
    data <- read.csv('studentInfo.csv')
    
    output$selector <- renderUI({
        
        selectInput(inputId = 'selector',label = 'Select region',choices = data$region)
    })
    
    output$radio <- renderUI({
        df <- distinct(data,final_result)
        radioButtons(inputId = 'radio',label = 'Choose final result', choices = df$final_result)
    })
    
    output$slider <- renderUI({ sliderInput(inputId = 'slider',label = 'Select student credits',min=30,max = 660,value = 30)
    })
    
    output$dt <-renderDT({
        
        
        datatable(data,options = list(input$radio,input$selector))
        
        
    })
    
    
    output$histo <- renderPlot({
        
        hist(data$studied_credits,probability = TRUE,breaks = as.numeric(input$slider),
             xlab = 'Studied Credits',main = "Student studied credits",col='blue')
        
        
    })
    
    output$dense <- renderPlot({
        
        
        ggplot(data,aes(data$studied_credits)) + geom_density(lwd=1,fill='blue') + 
            scale_x_continuous(name = 'Student Credits',breaks = as.numeric(input$slider))
        
        
             
        
    })
    
    
    
    
    
}

shinyApp(ui,server)