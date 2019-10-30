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

# Loading the model from disk
result <- readRDS("result3cut.rds")

# I-gram lookup function
SimplePredict <- function(sentence,i) {
    # keeping the last ´í' words of the sentence
    if(length(sentence) > i){
        sentence <- sentence[(length(sentence)-(i-1)):length(sentence)]
    }
    
    # concatenating the words into an i-gram
    sentence <- paste(sentence, collapse = " ")
    
    # looking for the i-gram in the model
    result[sentence][,2]
}

Predict <- function(sentence) {
    # replacing contractions and abreviations from imput sentence
    sentence <- replace_contraction(sentence)
    sentence <- replace_abbreviation(sentence)
    
    # tokenising the input sentence
    sentence <- tokens(sentence,
                       remove_numbers = TRUE,
                       remove_punct = TRUE,
                       remove_symbols = TRUE, 
                       remove_separators = TRUE,          
                       remove_twitter = TRUE, 
                       remove_hyphens = TRUE, 
                       remove_url = TRUE)
    
    # removing any non-alphabetical sequence
    sentence <- tokens_select(sentence, pattern = "^[a-zA-Z]*$", selection = "keep", valuetype = "regex", padding = FALSE)
    
    # loweringthe sentence
    sentence <- tolower(sentence$text1)
    
    # looking of an existing 5-gram
    output <- SimplePredict(sentence,5)
    
    # applying stupid backoff approach to lower n-grams
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
    
    # replacing NA by "" if no result
    ifelse(is.na(output[1]),output <- "",output)
}

# Define server logic
shinyServer(function(input, output, session) {
    
    # word prediction of input text
    prediction <- reactive({Predict(input$textInput)})
    
    # when text is inserted 
    observeEvent(input$textInput,{
            # replacing "data loading..." text once the model is loaded
            updateTextAreaInput(session, "textInput", label = "Enter your text:")
      
            # button value update with prediction 
            updateActionButton(session, "button1",
                               label = as.character(prediction()[1]))
    })
    
    # when button is clicked
    observeEvent(input$button1,{
            # adding predicted word to input sentence
            updateTextAreaInput(session, "textInput", value = paste(gsub(" $","",input$textInput),prediction()[1]))
        })
})
