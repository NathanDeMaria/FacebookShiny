library(shiny)
library(shinyIncubator)
library(ggvis)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  observe({
    if(input$submit == 0) {
      return()
    }
    
    isolate({
      withProgress(session, min = 0, max = input$pages_back + 3, {
        setProgress(message = 'Reading pages', value = 0)
        post_list <- get_json(token = input$token, pages_back = input$pages_back, group_id = input$group, update = T)
        
        setProgress(message = 'Parsing posts', value = input$pages_back + 1)
        post_data <- posts_to_dt(post_list)
        post_data %>% plot_averages() %>% bind_shiny('average_plot')
        post_data %>% plot_sums() %>% bind_shiny('sums_plot')
        post_data %>% plot_time() %>% bind_shiny('time_plot')
        
        output$all_posts <- renderDataTable(post_data)
        
        setProgress(message = 'Parsing likes', value = input$pages_back + 2)
        likes <- likes_to_dt(post_list)
        like_counts <- likes[,list(count=length(post_id)),by=list(poster, liker)][order(count, decreasing = T)]
        combined_likes <- combine_likes(like_counts)
        
        output$like_counts <- renderDataTable(like_counts)
        output$combined_likes <- renderDataTable(combined_likes)
        
        output$network <- renderText(create_d3(copy(like_counts)))
        print('done')
      })

    })
  })

})