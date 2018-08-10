library(stringr)
library(utf8)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(dplyr)
library(writexl)

library(devtools)
install_github("Avetik666/MartirosSaryan")
library(martirossaryan)
library(scales)

shinyApp(
    ui = dashboardPage(
      dashboardHeader(),
      dashboardSidebar( fileInput('file1', 'Input your image',
                                  accept = c(".jpg",".jpeg",".png")),
                        numericInput('number', 'Select number of colors', 4, min = 2, max = 10),
                        
                        actionButton(
                          inputId = "submit_loc",
                          label = "Submit"
                        )
      ),
      
      dashboardBody(fluidRow(
        box(imageOutput("img")),
        box(plotOutput("colors")))
      ))
    ,
    server = shinyServer(function(input, output) {
      
      
      
      
      observeEvent(
        eventExpr = input[["submit_loc"]],
        handlerExpr = {
          
          
          output$colors <-renderPlot({
            inFile1 <- input$file1
            
            show_col(getImagepallete(inFile1$datapath,input$number))
          })
          output$img <- renderImage({
            if (is.null(input$file1))
              return(NULL)
            inFile1 <- input$file1
            return(list(
              src = inFile1$datapath,
              height= 350,
              alt = "image"
            ))
          })
        })
      
      
    })
  )

