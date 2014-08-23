
require(dplyr)

# number of comments is 0 for comments shhh
parse_comment <- function(comment) {
  data.frame(
    poster=as.character(comment$from$name),
    message=as.character(comment$message),
    created_time=as.character(comment$created_time),
    likes=comment$like_count,
    comments=0,
    stringsAsFactors = FALSE
  )
}

# function for analyzing the mood of Raikes
get_text <- function(post) {
  
  if(is.null(post$message)) {
    post$message[1] <- ''
  }
  
  p <- data.frame(
    poster=as.character(post$from$name),
    message=as.character(post$message),
    created_time=as.character(post$created_time),
    likes=length(post$likes$data),
    comments=length(post$comments$data),
    stringsAsFactors = FALSE
  )
  
  if(is.null(post$comment)) {
    return(p)
  }
  
  # comments is post$comment$data
  comments <- rbind_all(lapply(post$comments$data, parse_comment))
  
  return(rbind_list(p, comments))
}


