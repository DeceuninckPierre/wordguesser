#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinycssloaders)
library(shinythemes)

# Options for Spinner
options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("slate"),
    # Application title
    
    fluidRow(align="center",titlePanel("Word Guesser")),
    fluidRow(align="center",textOutput("Loading")),
    fluidRow(align="center",textInput("textInput","Enter your text:",width="606px")),
    fluidRow(align="center",actionButton("button1","", style = "width:200px; height:40px"),
        actionButton("button2","", style = "width:200px; height:40px") ,
        actionButton("button3","", style = "width:200px; height:40px") 
        )
        )

   

   # fluidRow(
#        column(4,
#               textOutput(outputId = "textOutput1") %>% withSpinner(color="#0dc5c1")
#        ),
#        column(4,
#               textOutput(outputId = "textOutput2") %>% withSpinner(color="#0dc5c1")
#        ),
#        column(4,
#               textOutput(outputId = "textOutput3") %>% withSpinner(color="#0dc5c1")
#        )
#    )  
     
    
#)

)
