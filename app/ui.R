library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
  
  # dummy for the progress bar
  progressInit(),
  
  titlePanel("Facebook Shiny App"),
  
  # including a 'dummy' output so it adds 
  # the ggvis and dataTable style/scripts to head
  ggvisOutput('dummy'),
  dataTableOutput('dummer'),
  
  bootstrap_tabs(list(
      Submit = paste0(
                tags$h4('Get an API key', tags$a('here', href='https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.0')),
                tags$p('Make sure you check user_groups'),
                textInput('token', label = 'API Token', value = app_settings['api_token','values',with=F][[1]]),         
                textInput('group', label = 'Facebook group id', value = app_settings['cohort_page','values',with=F][[1]]),
                numericInput(inputId = 'pages_back', label = 'Pages back', value = 4, min = 0, max = 100),
                tags$br(),
                actionButton(inputId = 'submit', label = 'Update graphs'), collapse='\n'),
      Average = ggvisOutput('average_plot'),
      Sums = ggvisOutput('sums_plot'),
      Time = ggvisOutput('time_plot'),
      Likes = dataTableOutput('like_counts'),
      Pairs = dataTableOutput('combined_likes'),
      Posts = dataTableOutput('all_posts'),
      Network = paste0(tags$div(id='container'), htmlOutput('network'))
    ))
))