library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Facebook Shiny App"),
  
  mainPanel(
    tags$h4('Get an API key', tags$a('here', href='https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.0
')),
    tags$p('Make sure you check user_groups'),
    textInput('token', label = 'API Token', 
              # yes, this is my actual key shhh
              value = 'CAACEdEose0cBAMeZCLChAGWZAVIpVtgz5cC87b2dJIQKnxQmRJCIqr9ouAaF0fpZBZC8CWmcWeBATZBwWXWWdWvPXxlKS5WdDlcE6TNMBi81QOEZBJiRZBCbBXD7p8Noy3iIlJsnIKbu7ZB2AxLMOJxKWxeprKPecuw8QaV6kbZChwWCGQYzuX8k04NNQ9FWZCT4YZA2W02ANLe0W2aYoXfqZABo'),
    
    textInput('group', label = 'Facebook group id', value = '370400073020145'),
    numericInput(inputId = 'pages_back', label = 'Pages back', value = 4, min = 0, max = 100),
    actionButton(inputId = 'submit', label = 'Update graphs'),
    ggvisOutput('average_plot')
  )
))