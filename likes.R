
get_likes <- function(token, pages_back) {
  
  original_url <- paste0('https://graph.facebook.com/370400073020145/feed?access_token=', token)
  
  page <- get_page(original_url)
  
  likes <- rbind_all(lapply(page$data, get_post_likes))
  
  if(pages_back > 0) {
    for(i in 1:pages_back) {
      
      page <- get_page(page$paging['next'])
      
      # definitely need to change the way I'm combining things
      next_likes <- rbind_all(lapply(page$data, get_post_likes))
      likes <- rbind(likes, next_likes)
    }
  }  
  
  likes
}

get_post_likes <- function(post) {
  
  if(is.null(post$likes)) {
    return(NULL)
  }

  data.frame(
    poster = post$from$name,
    post_id = post$id,
    liker = sapply(post$likes$data, 
                    function(like) {like$name}),
    stringsAsFactors=F
  )
}

d3_force_likes <- function(df) { 
  
  df[,poster:=as.character(poster)]
  df[,liker:=as.character(liker)]
  
  lookup <- data.table(name=unique(c(df$poster, df$liker)))
  lookup[,index:=0:(dim(lookup)[1] - 1)]
  
  setkey(lookup, name)
  
  # gives warnings because this isn't really how you use
    # data.table joins, but it works :)
  invisible(suppressWarnings(df[,source:=lookup[liker, 'index',with=F]]))
  invisible(suppressWarnings(df[,target:=lookup[poster, 'index',with=F]]))
  df[,distance:=1/count]
  
  usr_names <- lookup[order(index)]$name
  
  links <- lapply(1:length(df$source), function(x) {
    list(source=df$source[x], target=df$target[x], distance=df$distance[x])
  })
  
  nodes <- lapply(usr_names, function(x) {
    list(name=x)
  })
  
  data <- list(nodes = nodes, links = links)
  
  toJSON(data)
}

