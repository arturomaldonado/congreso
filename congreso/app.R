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
library(rio)
congreso <- import("TotalCongreso_11OCT.xlsx")
votaciones <- import("votaciones.xlsx")

# Definir UI para tabla interactiva de PL
ui <- fluidPage(
    titlePanel("Proyectos de Ley"),
    sidebarLayout(
        sidebarPanel(
            conditionalPanel(
                #Input: seleccionar variables
                'input.dataset === "congreso"',
                checkboxGroupInput("show_vars", "Columnas para mostrar:",
                                names(congreso), selected=names(congreso)),
                
                #Input: seleccionar bancada
                selectInput("ban", "Bancada",
                            choices=c("All",
                                      unique(as.character(congreso$Grupo.Parlamentario)
                                             )
                                      )
                ),
            ),
            conditionalPanel(
                'input.dataset === "votaciones"',
                helpText("Mostrar 5 registros por defecto")
            ),
            actionButton("update", "Actualizar")
        ),
        mainPanel(
            tabsetPanel(
                id='dataset',
                tabPanel("congreso", DT::dataTableOutput("tabla1")),
                tabPanel("votaciones", DT::dataTableOutput("tabla2"))
            )
        )
    )
)

# Definir server logic para tabla de PL
server <- function(input, output) {
    #Escoger columnas y bancadas
    data<-congreso
    output$tabla1 <- DT::renderDataTable({
        if(input$ban !="All"){
            data<-data[data$Grupo.Parlamentario==input$ban,]
        DT::datatable(data[, input$show_vars, drop=FALSE])
        }
    })
        
    #5 filas por página
    output$tabla2 <- renderDataTable({
        DT::datatable(votaciones, options=list(lengthMenu=c(5,30,50), pageLength=5))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
