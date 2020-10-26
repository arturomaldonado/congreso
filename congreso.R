#Cargando librerias básicas#
library(rio) # Para importar los datos
library(ggplot2) # Para hacer gráficos tipo ggplot
library(Rmisc) # Para poder usar la función summarySE
library(descr) # Para poder usar la función crosstab y compmeans

congreso <- import("TotalCongreso_11OCT.xlsx")
votaciones <- import("votaciones.xlsx")
congreso2 = congreso[sample(nrow(congreso), 1000),]

fluidRow(
  column(4,
         selectInput("ban",
                     "Bancada",
                     c("All",
                       unique(as.character(congreso$Grupo.Parlamentario))))
  ),
  column(4,
         selectInput("prop",
                     "Proponente",
                     c("All",
                       unique(as.character(congreso$Autor))))
  ),
  column(4,
         selectInput("com",
                     "Comisión",
                     c("All",
                       unique(as.character(congreso$Comisión1))))
  )
),


DT::datatable({
  data<-congreso2
  if(input$leg !="All") {
    data<-data[data$legislatura==input$leg,]
  }
  if(input$banca !="All"){
    data<-data[data$Grupo.Parlamentario==input$banca,]
  }
  if(input$aut != "All"){
    data<-data[data$Autor==input$aut,]
  }
  if(input$com !="All"){
    data<-data[data$Comision1==input$com,]
  }
  data
})

}