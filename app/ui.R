library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
  
  # dummy for the progress bar
  progressInit(),
  
  titlePanel("Facebook Shiny App"),

  tabsetPanel(id = 'tabs',
      tabPanel('Submit',
                tags$h4('Get an API key', tags$a('here', href='https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.0')),
                tags$p('Make sure you check user_groups'),
                textInput('token', label = 'API Token', value = app_settings['api_token','values',with=F][[1]]),         
                textInput('group', label = 'Facebook group id', value = app_settings['cohort_page','values',with=F][[1]]),
                numericInput(inputId = 'pages_back', label = 'Pages back', value = 4, min = 0, max = 100),
                tags$br(),
                actionButton(inputId = 'submit', label = 'Update graphs'), collapse='\n'),
      tabPanel('Sentiment', tabsetPanel(id = 'sentiment_tabs', 
                                        tabPanel('Average', ggvisOutput('average_plot')),
                                        tabPanel('Sums', ggvisOutput('sums_plot')))),          
      tabPanel('Time', ggvisOutput('time_plot'), uiOutput('time_ui')),
      tabPanel('Frequency', ggvisOutput('time_freq_plot'), uiOutput('time_freq_ui')),
      tabPanel('Likes', tabsetPanel(id = 'like_tabs',
                                    tabPanel('Counts', dataTableOutput('like_counts')),
                                    tabPanel('Pairs', dataTableOutput('combined_likes')))),
      tabPanel('Posts', dataTableOutput('all_posts')),
      tabPanel('Network', tabsetPanel(id = 'network_tabs',
                                      tabPanel('D3Network', tags$div(id='container'), htmlOutput('network_d3')),
                                      tabPanel('Network', plotOutput('network_plot', width = 1000, height = 1000))))
    )
))