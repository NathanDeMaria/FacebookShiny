
require(data.table)

likes_to_dt <- function(post_json_list) {
  rbindlist(lapply(post_json_list, get_post_likes))
}

get_post_likes <- function(post) {
  
  if(is.null(post$likes)) {
    return(NULL)
  }

  data.table(
    poster = post$from[['name']],
    post_id = post$id,
    liker = sapply(post$likes$data, 
                    function(like) {like[['name']]})
  )
}

d3_force_likes <- function(dt) { 
  
  dt[,poster:=as.character(poster)]
  dt[,liker:=as.character(liker)]
  
  lookup <- data.table(name=unique(c(dt$poster, dt$liker)))
  lookup[,index:=0:(dim(lookup)[1] - 1)]
  
  setkey(lookup, name)
  
  # gives warnings because this isn't really how you use
    # data.table joins, but it works :)
  invisible(suppressWarnings(dt[,source:=lookup[liker, 'index',with=F]]))
  invisible(suppressWarnings(dt[,target:=lookup[poster, 'index',with=F]]))
  dt[,distance:=1/count]
  
  usr_names <- lookup[order(index)]$name
  
  links <- lapply(1:length(dt$source), function(x) {
    list(source=dt$source[x], target=dt$target[x], distance=dt$distance[x])
  })
  
  nodes <- lapply(usr_names, function(x) {
    list(name=x)
  })
  
  data <- list(nodes = nodes, links = links)
  
  toJSON(data)
}

