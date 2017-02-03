library(shiny)
library(EBImage)
library(displayWidget)

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("EBImage display widget"),

   # Sidebar with a select input for the image
   sidebarLayout(
      sidebarPanel(
         selectInput("image", "Sample image:", list.files(system.file("images", package="EBImage")))
      ),

      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel("Static display", plotOutput("display")),
          tabPanel("Interactive widget", displayWidgetOutput("widget"))
        )
      )
   )
)

server <- function(input, output) {

   img <- reactive({
     f = system.file("images", input$image, package="EBImage")
     x = readImage(f)
   })

   output$widget <- renderDisplayWidget({
     displayWidget(img())
   })

   output$display <- renderPlot({
     display(img(), method="raster")
   })
}

# Run the application
shinyApp(ui = ui, server = server)
