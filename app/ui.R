library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Facebook Shiny App"),
  
  mainPanel(
    HTML('
      <div>
        <ul id="myTab" class="nav nav-tabs">
          <li class="active"><a href="#submit" data-toggle="tab">Submit</a></li>           
          <li><a href="#average" data-toggle="tab">Average</a></li>
          <li><a href="#sum" data-toggle="tab">Total</a></li>
          <li><a href="#time" data-toggle="tab">Time</a></li>
        </ul>
        <div id="myTabContent" class="tab-content">
          <div class="tab-pane active" id="submit">'),
            tags$h4('Get an API key', tags$a('here', href='https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.0
')),
            tags$p('Make sure you check user_groups'),
            textInput('token', label = 'API Token', 
              # yes, this is my actual key shhh
              value = 'CAACEdEose0cBAMeZCLChAGWZAVIpVtgz5cC87b2dJIQKnxQmRJCIqr9ouAaF0fpZBZC8CWmcWeBATZBwWXWWdWvPXxlKS5WdDlcE6TNMBi81QOEZBJiRZBCbBXD7p8Noy3iIlJsnIKbu7ZB2AxLMOJxKWxeprKPecuw8QaV6kbZChwWCGQYzuX8k04NNQ9FWZCT4YZA2W02ANLe0W2aYoXfqZABo'),
    
    textInput('group', label = 'Facebook group id', value = '370400073020145'),
    numericInput(inputId = 'pages_back', label = 'Pages back', value = 4, min = 0, max = 100),
    actionButton(inputId = 'submit', label = 'Update graphs'),
    HTML('</div>
          <div class="tab-pane" id="average">'),
            ggvisOutput('average_plot'),
    HTML('</div>
          <div class="tab-pane" id="sum">'),
            ggvisOutput('sums_plot'),
    HTML('</div>
          <div class="tab-pane" id="time">'),
            ggvisOutput('time_plot'),
    HTML('</div>
        </div>
      </div>')
  )
))