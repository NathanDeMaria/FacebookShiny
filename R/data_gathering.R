
require(data.table)
require(RJSONIO)
require(httr)

get_json <- function(token, pages_back, group_id, update = F) {
  
  # this is the cohort page vvv
  original_url <- paste0('https://graph.facebook.com/', group_id, '/feed?access_token=', token)
  
  page <- get_page(original_url)
  if(!is.null(page$error$message) && page$error$message=='Invalid OAuth access token.'){
    stop('Invalid OAuth token')
  }
  
  posts <- page$data
    
  # I'm so sorry, but I've gotta :(
  if(pages_back > 0) {
    for(i in 1:pages_back) {
      
      page <- get_page(page$paging['next'])
      
      if(update) {
        setProgress(value = i)
      }
      
      # definitely need to change the way I'm combining things
      posts <- c(page$data, posts)
    }
  }
  
  return(posts)
}

clean_json <- function(str) {
  
  # cleans out when Ryan said: "{\"message\":\"C:Windows//Media//Onestop.mid\n\nThat is all.\"}"
  str <- gsub('\\\\W', '//W', str)
  str <- gsub('\\\\M', '//M', str)
  str <- gsub('\\\\O', '//O', str)
  
  # because of ¯\\_(ツ)_/¯
  gsub('¯\\\\_\\(.\\)_/¯', 'shrug', str)
}

get_page <- function(url) {
  
  resp <- GET(url)
  
  cleaned <- clean_json(resp)
  
  return(fromJSON(cleaned))
}


