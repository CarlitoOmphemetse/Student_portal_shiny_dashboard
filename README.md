# Student_portal_shiny_dashboard

The Student Information Portal contains a data file inside the folder sent where the App resides. When running the App, please be patient as the data loads inside the app. 

Used libraries 
library(shiny) # for creating shiny webapp
library(shinydashboard) #for creating a shinydashboard
library(remotes) #
library(DT) #for designing a well formatted table
library(ggplot2) #for plotting graphs
library(dplyr) # for Data Munging

Current Directory
setwd('./')
This piece of code allows you use the data from you current directory. NB: This was made so because the data is included inside the folder.

User interface
ui <- dashboardPage(skin='blue',
                    dashboardHeader(title = 'Student Information Portal'),
                    dashboardSidebar(
                            sidebarMenu(
                            menuItem('Data Table',tabName = 'first'),
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
The user interface (ui) section contains only the design structure of the dashboard, and uiOutput to pull the functionality of the dashboard from the back end(server). 
The sidebarMenu contains two tabs, namely 'Data Table' and 'Plots'. On the Data Table tab, there is a table produced the DT package. The table is interactive using the selectInput and radioButtons functions,  you can select a region of your choice and a final_result. In addition, this functionality works like a filter to select the exact observations you looking for in the data. 
Then for the second tab named 'Plots' there are two plots available created using ggplot2 package.  The Plots section visualizes a histogram and a density plot for studied_credits field.

NB: The selectInput and radioButtons are used for the first tab 'Data Table', and sliderInput is used for the second tab 'Plots'.

Server
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
The server side of the dashboard consists of the main functionality of the dashboard. The data is imported on this section. The server consists of the renderUI for rendering the produced functionality that is being selected by the user, as mentioned before that uiOutput is to ouput some input that is from this section. renderPlot is used for plotting the data into graphs, renderDT renders the table created from the data as input.
