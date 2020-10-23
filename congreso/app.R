#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Definir UI para tabla interactiva de PL
ui <- fluidPage(
    titlePanel("Proyectos de Ley"),
    #Una nueva fila en IU para selectInputs
    fluidRow(
        column(4,
               selectInput("leg",
                           "Legislatura",
                           c("All",
                             unique(as.character(congreso$Legislatura))))
               ),
        column(4,
               selectInput("banca",
                           "Bancada",
                           c("All",
                             unique(as.character(congreso$Grupo.Parlamentario))))
               ),
        column(4,
               selectInput("prop",
                           "Proponente",
                           c("All",
                             unique(as.character(congreso$Autor))))
               )
    ),
    #Crear una nueva fila para la tabla#
    DT::dataTableOutput("tabla")
)

# Definir server logic para tabla de PL
server <- function(input, output) {
    output$tabla <- DT::renderDataTable(DT::datatable({
        data<-congreso
        if(input$leg !="All") {
            data<-data[data$legislatura==input$leg,]
        }
        if(input$banca !="All"){
            data<-data[data$Grupo.Parlamentario==input$banca,]
        }
        if(input$prop != "All"){
            data<-data[data$Autor==input$prop,]
        }
        data
    }))
    
}

# Run the application 
shinyApp(ui = ui, server = server)
