#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quanteda)
library(data.table)
library(qdap)
library(shinyjs)

result <- readRDS("result2.rds")

SimplePredict <- function(sentence,i) {
    
    #sentence <- tolower(sentence)
    
    
    
    if(length(sentence) > i){
        sentence <- sentence[(length(sentence)-(i-1)):length(sentence)]
    }
    
    sentence <- paste(sentence, collapse = " ")
    
    print(sentence)
    
    output <- result[sentence]
    
    output <- unlist(output[,2:4])
    
    output
}

SimplePredict2 <- function(sentence) {
    
    sentence <- replace_contraction(sentence)
    sentence <- replace_abbreviation(sentence)
    
    sentence <- tokens(sentence,
                       remove_numbers = TRUE,
                       remove_punct = TRUE,
                       remove_symbols = TRUE, 
                       remove_separators = TRUE,          
                       remove_twitter = TRUE, 
                       remove_hyphens = TRUE, 
                       remove_url = TRUE)
    
    #str(sentence)
    
    #sentence.token <- tokens(sentence)
    
    #sentence <- tokens_select(sentence, readLines("en_curse_words.txt"), selection = "remove", padding = FALSE)
    #sentence <- tokens_select(sentence, pattern = dico.98.cover, selection = "keep", padding = FALSE)
    sentence <- tokens_select(sentence, pattern = "^[a-zA-Z]*$", selection = "keep", valuetype = "regex", padding = FALSE)
    
    #sentence <- unlist(strsplit(sentence," "))
    
    sentence <- tolower(sentence$text1)
    
    output <- SimplePredict(sentence,5)
    
    if(is.na(output[1])) {
        output <- SimplePredict(sentence,4)
        
        if(is.na(output[1])) {
            output <- SimplePredict(sentence,3)
            
            if(is.na(output[1])) {
                output <- SimplePredict(sentence,2)
                
                if(is.na(output[1])) {
                    output <- SimplePredict(sentence,1)
                }
            }
        }
        
    }
    
    print(output)
    
    ifelse(is.na(output[1]),output <- c("","",""),output)
    
    print(output)
    
    output
}



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    test <- reactive({SimplePredict2(input$textInput)})
    
    observe({
        req(input$textInput)
        
        updateActionButton(session, "button1",
                       label = as.character(test()[1]))
        
        updateActionButton(session, "button2",
                           label = as.character(test()[2]))
        
        updateActionButton(session, "button3",
                           label = as.character(test()[3]))
    })
    
    observeEvent(input$button1,{
        updateTextInput(session, "textInput", value = paste(gsub(" $","",input$textInput),test()[1]))
        })
    
    observeEvent(input$button2,{
        updateTextInput(session, "textInput", value = paste(gsub(" $","",input$textInput),test()[2]))
    })
    
    observeEvent(input$button3,{
        updateTextInput(session, "textInput", value = paste(gsub(" $","",input$textInput),test()[3]))
    })
    
    


})
