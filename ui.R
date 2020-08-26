shinyUI(
  fluidPage(
    titlePanel("Bayesian Coin App"), 
    sidebarLayout(
      
      sidebarPanel = sidebarPanel(
        
        h4("Approximate Bayesian Computation:"),
        
        numericInput("m", "Enter number of simulation:", 
                     value = 1e4, max = 1e7, min = 1),
        
        selectInput("prior", "Select prior distribution:", 
                    choices = c("Beta" = "beta", 
                                "Truncated Normal" = "tnorm")),
        
        h4("The parameter of prior:"), 
        conditionalPanel(
          "input.prior == 'beta'", 
          sliderInput("alpha", "Enter alpha:", value = 2, min =0, 
                      max = 100, step = 0.1),
          sliderInput("beta", "Enter beta:", min =0, max = 100,
                      value = 5, step = 0.1)
        ), 
        conditionalPanel(
          "input.prior == 'tnorm'", 
          sliderInput("mu", "Enter mu:", value = 0.5, min =0, 
                      max = 1, step = 0.01),
          sliderInput("sigma", "Enter sigma:", min =0, max = 1, 
                      value = 0.1, step = 0.1)
        ), 
        
        h4("Likelihood:"), 
        
        sliderInput("n", "Enter n:", min = 1, max = 200, 
                    value = 10), 
        
        sliderInput("x", "Enter x:", min = 1, max = 200, 
                    value = 6)
      ), 
      mainPanel = mainPanel( 
        tabPanel(
          title = "Plot data", id = "plot", 
          br(),
          downloadButton("downloadPlot", "Save Figure"),
          br(), br(),
          plotOutput("plot")
        )
      )
    )
  )
)