
require(data.table)

posts_to_dt <- function(post_json_list) {
  post_data <- rbindlist(lapply(post_json_list, get_text))
  
  post_data[,score:=score_text(message)]
  post_data[,created_time:=ymd_hms(created_time)]
  post_data
}

# number of comments is 0 for comments shhh
parse_comment <- function(comment) {
  data.table(
    poster=as.character(comment$from[['name']]),
    message=as.character(comment$message),
    created_time=as.character(comment$created_time),
    likes=comment$like_count,
    comments=0
  )
}

# function for analyzing the mood of Raikes
get_text <- function(post) {
  
  if(is.null(post$message)) {
    post$message[1] <- ''
  }
  
  p <- data.table(
    poster=as.character(post$from[['name']]),
    message=as.character(post$message),
    created_time=as.character(post$created_time),
    likes=length(post$likes$data),
    comments=length(post$comments$data)
  )
  
  if(is.null(post$comment)) {
    return(p)
  }
  
  # comments is post$comment$data
  comments <- rbindlist(lapply(post$comments$data, parse_comment))
  
  return(rbindlist(list(p, comments)))
}


