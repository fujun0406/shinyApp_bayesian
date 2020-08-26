library(truncnorm)
shinyServer(function(input, output, session){
  
  observeEvent(input$n, {
    updateSliderInput(session, "x", max = input$n)
  })
  
  marg_lik = reactive({
    integrate(dbinom, 0, 1, x = input$x, size = input$n)$value
  })
  
  d = tibble(p = seq(0, 1, length.out = 101))
  
  d_prior = reactive({
    if (input$prior == 'beta') {
      mutate(d, prior = dbeta(p, input$alpha, input$beta))
    } else if (input$prior == 'tnorm') {
      mutate(d, prior = dtruncnorm(p, a = 0, b = 1, 
                                   mean = input$mu, 
                                   sd = input$sigma))
    }
  })
  
  d_prior_lik = reactive({
    d_prior() %>% 
      mutate(likelihood = dbinom(input$x, size = input$n, 
                                 prob = p) / marg_lik())
  })
  
  d_prior_lik_post = reactive({
    if (input$prior == 'beta') {
      d_prior_lik() %>% 
        mutate(posterior = dbeta(p, input$alpha + input$x, 
                                 input$beta + input$n - input$x))
    } else if (input$prior == 'tnorm'){
      d_prior_lik()
    }
  })
  
  prior = reactive({
    if (input$prior == 'beta') {
      rbeta(input$m, input$alpha, input$beta)
    } else if (input$prior == 'tnorm') {
      rtruncnorm(input$m, a = 0, b = 1, 
                 mean = input$mu, sd = input$sigma)
    }
  })
  
  buildPlot <- reactive({
    prob = prior()
    x_sim = rbinom(input$m, input$n, prob)
    post_abc = prob[x_sim == input$x]
    density_abc = density(post_abc)
    
    plot <- d_prior_lik_post() %>%  
      pivot_longer(-p, names_to = "Distribution", 
                   values_to = "Density") %>% 
      bind_rows(
        tibble(
          p = density_abc$x, 
          Distribution = "posterior (ABC)", 
          Density = density_abc$y
        )
      ) %>% 
      ggplot(aes(x = p, y = Density, color = Distribution)) + 
      geom_line(size = 1) +
      theme(axis.text.x = element_text(size = 14),
            axis.text.y = element_text(size = 14),
            axis.title.x = element_text(size = 18),
            axis.title.y = element_text(size = 18), 
            legend.position = "bottom", 
            legend.title = element_text(size = 14), 
            legend.text = element_text(size = 14))
    
    plot
  })
  
  output$plot <-
    renderPlot(
      {
        buildPlot()
      },
      height = 500,
      width = "auto",
      units = "px", 
      res = 100
    )
  
  output$downloadPlot <- downloadHandler(
    filename = function() {
      "SavePlot.pdf"
    },
    
    content = function(file) {
      pdf(file,
          width = 10,
          height = 10)
      print(buildPlot())
      dev.off()
    }
  )
})