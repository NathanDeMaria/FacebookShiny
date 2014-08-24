
likes_to_dt <- function(post_json_list) {
  data.table(rbind_all(lapply(post_json_list, get_post_likes)))
}

get_post_likes <- function(post) {
  
  if(is.null(post$likes)) {
    return(NULL)
  }

  data.frame(
    poster = post$from[['name']],
    post_id = post$id,
    liker = sapply(post$likes$data, 
                    function(like) {like[['name']]}),
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

