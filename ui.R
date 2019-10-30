#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application using Slate shiny theme
shinyUI(fluidPage(theme = shinytheme("slate"),
    # Application title
    fluidRow(align="center",titlePanel("Word Guesser")),
    
    # Text Area with label set to "Data loading..."
    fluidRow(align="center",textAreaInput("textInput","Loading data, please wait...", value = "",height="150px",resize = "vertical")),
    
    # Help text informing user that the predicted word can be clicked
    helpText(align="center","Predicted next word:","(click to select)"),
    
    # Button have the predicted word as label
    fluidRow(align="center",actionButton("button1","", style = "width:300px; height:40px"))
    )
)
