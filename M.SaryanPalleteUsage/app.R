
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

df  <- readxl::read_xlsx("Export data.xlsx", sheet = "Sheet1", col_names = TRUE) #Reading the file

df$Price <- as.numeric(df$Price)
df <- df[order(df$Price),]
df$Name <- factor(df$Name,levels = df$Name)
len <- dim(df)[1]
images <- getPalleteNames()

shinyApp( 
    ui = dashboardPage(
      dashboardHeader(),
      dashboardSidebar( 
                        selectInput('image', 'Select one of the images of Martiros Saryan', choices = images),
                        
                        actionButton(
                          inputId = "submit_loc",
                          label = "Submit"
                        )
      ),
      
      dashboardBody(
        
        plotOutput("colors"),
        imageOutput("image")
      ))
    ,
    server = shinyServer(function(input, output) {
      
      
      
      
      observeEvent(
        eventExpr = input[["submit_loc"]],
        handlerExpr = {
          
          output$colors <-renderPlot({
            image <- input$image
            palette<- getSaryanPallete(image)
            
            ggplot(df, aes(x=df$Name,y=df$Price))+geom_bar(stat="identity", fill = palette[1:len] ) +
              labs(x = "Products", y = "Total Export($)"
                   ,title="Export of products from RA",subtitle = "2018 year, Jan-Jun") +
              geom_text(aes(label=round(df$Price,1),y=df$Price),hjust=-1)+
              scale_y_continuous(breaks= seq(0,max(df$Price)+50,25),limits=c(0, max(df$Price)+50)) +
              theme_minimal()+
              theme(axis.text.x = element_text(size=8,face="bold"),
                    axis.text.y = element_text(size=10,face="bold"))+
              coord_flip()
          })
          output$image <- renderImage({
            if (is.null(input$image))
              return(NULL)
            
            
              return(list(
                src = paste0("ms/",input$image,".jpg"),
                height= 350,
                alt = "image"
              ))
            
            
          }, deleteFile = FALSE)
        })
      
      
    })
  )

