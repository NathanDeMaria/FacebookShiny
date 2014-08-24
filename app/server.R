library(shiny)
library(ggvis)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  observe({
    if(input$submit == 0) {
      return()
    }
    
    isolate({
      post_list <- get_json(token = input$token, pages_back = input$pages_back, group_id = input$group)
      post_data <- posts_to_dt(post_list)
      post_data %>% plot_averages() %>% bind_shiny('average_plot')
    })
  })

})