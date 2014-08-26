library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Facebook Shiny App"),
  
  # including a 'dummy' output so it adds the ggvis style/scripts to head
  ggvisOutput('dummy'),
  dataTableOutput('dummer'),
  bootstrap_tabs(list(
      Submit = HTML(paste0(tags$h4('Get an API key', tags$a('here', href='https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.0')),
                     tags$p('Make sure you check user_groups'),
                     textInput('token', label = 'API Token', 
                       # yes, this is my actual key shhh
                       value = 'CAACEdEose0cBAMeZCLChAGWZAVIpVtgz5cC87b2dJIQKnxQmRJCIqr9ouAaF0fpZBZC8CWmcWeBATZBwWXWWdWvPXxlKS5WdDlcE6TNMBi81QOEZBJiRZBCbBXD7p8Noy3iIlJsnIKbu7ZB2AxLMOJxKWxeprKPecuw8QaV6kbZChwWCGQYzuX8k04NNQ9FWZCT4YZA2W02ANLe0W2aYoXfqZABo'),
             
             textInput('group', label = 'Facebook group id', value = '370400073020145'),
             numericInput(inputId = 'pages_back', label = 'Pages back', value = 4, min = 0, max = 100),
             tags$br(),
             actionButton(inputId = 'submit', label = 'Update graphs'), collapse='\n')),
      Average = ggvisOutput('average_plot'),
      Sums = ggvisOutput('sums_plot'),
      Time = ggvisOutput('time_plot'),
      Likes = dataTableOutput('like_counts'),
      Pairs = dataTableOutput('combined_likes'),
      Posts = dataTableOutput('all_posts'),
      Network = HTML(paste0(tags$div(id='container'), htmlOutput('network')))
    ))
))