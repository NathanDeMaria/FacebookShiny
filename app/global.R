
# packages ####
library(RCurl)
library(rjson)
library(lubridate)
library(stringr)
library(ggvis)
library(data.table)

source('../R/parsing.R')
source('../R/data_gathering.R')
source('../R/scoring.R')
source('../R/visualize.R')
source('../R/likes.R')

# needed for SSL stuff using curl on Windows
if(!file.exists('../cacert.pem')) {
  download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="../cacert.pem")
}

# takes in a named list of things to put in tabs
bootstrap_tabs <- function(tab_list) {
  begin <- 
    '<div>
      <ul id="myTab" class="nav nav-tabs">'
  
  if(any(names(tab_list) == '')) {
    stop('All items in the list must be named')
  }
  
  active_tab <- paste0('<li class="active"><a href="#', 
                       names(tab_list)[1], 
                       '" data-toggle="tab">', 
                       names(tab_list)[1], 
                       '</a></li>')
  other_tabs <- sapply(names(tab_list)[-1], function(name) {
    paste0('<li><a href="#', name, 
           '" data-toggle="tab">', name, 
           '</a></li>')
  })
  
  tabs <- paste0(c(active_tab, other_tabs), collapse='\n')
  
  
  middle <- '
        </ul>
        <div id="myTabContent" class="tab-content">'
  
  active_content <- paste0('<div class="tab-pane active" id="', 
                           names(tab_list)[1], '">',
                           tab_list[[1]], '</div>')
  
  other_content <- mapply(function(name, tab_content) {
    paste0('<div class="tab-pane" id="', name, '">',
           tab_content,
           '</div>')
  }, names(tab_list[-1]), tab_list[-1])
  
  content <- paste0(c(active_content, other_content), collapse='\n')
  
  end <- '
      </div>
  </div>'
  
  HTML(paste0(c(begin, tabs, middle, content, end), collapse='\n'))
}
