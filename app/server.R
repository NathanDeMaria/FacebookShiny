library(shiny)
library(shinyIncubator)
library(ggvis)
library(igraph)

shinyServer(function(input, output, session) {
  
  observe({
    
    # exit if not button click
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
        post_data %>% plot_time() %>% 
          layer_smooths(span = input_slider(.05, .3, value=.1, label='Smoothing span'), 
                        stroke := 'blue') %>% 
          bind_shiny('time_plot', 'time_ui')
        
        output$all_posts <- renderDataTable(post_data)
        
        setProgress(message = 'Parsing likes', value = input$pages_back + 2)
        likes <- likes_to_dt(post_list)
        like_counts <- likes[,list(count=length(post_id)),by=list(poster, liker)][order(count, decreasing = T)]
        combined_likes <- combine_likes(like_counts)
        
        output$like_counts <- renderDataTable(like_counts)
        output$combined_likes <- renderDataTable(combined_likes)
        
        output$network_d3 <- renderText(create_d3(copy(combined_likes)))
        
        output$network_plot <- renderPlot({
          adjacency_matrix <- get_adj_matrix(like_counts)
          
          g <- graph.adjacency(adjacency_matrix, weighted = T)
          plot(g)
        })
        
        print('done')
      })

    })
  })

})