
require(data.table)
require(RJSONIO)

get_all <- function(token, pages_back) {
  
  # this is the cohort page vvv
  original_url <- paste0('https://graph.facebook.com/370400073020145/feed?access_token=', token)
  
  posts <- get_page(original_url)
  if(!is.null(posts$error$message) && posts$error$message=='Invalid OAuth access token.'){
    stop('Invalid OAuth token')
  }
  
  everything <- rbind_all(lapply(posts$data, get_text))
  
  # I'm so sorry, but I've gotta :(
  if(pages_back > 0) {
    for(i in 1:pages_back) {
      
      posts <- get_page(posts$paging['next'])
      
      # definitely need to change the way I'm combining things
      next_posts <- rbind_all(lapply(posts$data, get_text))
      everything <- rbind(everything, next_posts)
    }
  }
  
  everything <- data.table(everything)
  everything[,created_time:=ymd_hms(created_time)]
    
  return(everything)
}


get_page <- function(url) {
  
  resp <- getURL(url)
  
  resp <- clean_json(resp)
  
  return(fromJSON(resp))
}

clean_json <- function(str) {
  
  # cleans out when Ryan said: "{\"message\":\"C:Windows//Media//Onestop.mid\n\nThat is all.\"}"
  str <- gsub('\\\\W', '//W', str)
  str <- gsub('\\\\M', '//M', str)
  str <- gsub('\\\\O', '//O', str)
  
  # because of ¯\\_(ツ)_/¯
  str <- gsub('¯\\\\_\\(.\\)_/¯', 'shrug', str)
}

