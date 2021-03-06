
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
  
  lookup <- data.table(name=unique(c(dt$person_a, dt$person_b)))
  lookup[,index:=0:(dim(lookup)[1] - 1)]
  
  setkey(lookup, name)
  
  # gives warnings because this isn't really how you use
    # data.table joins, but it works :)
  invisible(suppressWarnings(dt[,source:=lookup[person_a, 'index',with=F]]))
  invisible(suppressWarnings(dt[,target:=lookup[person_b, 'index',with=F]]))
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

combine_likes <- function(like_counts) {
  # this is gross, but it was a quick fix
  in_first <- like_counts$liker < like_counts$poster
  first <- data.table(person_a = like_counts$liker[in_first],
                      person_b = like_counts$poster[in_first],
                      count = like_counts$count[in_first])
  second <- data.table(person_a = like_counts$poster[!in_first],
                       person_b = like_counts$liker[!in_first],
                       count = like_counts$count[!in_first])
  combined <- rbindlist(list(first, second))
  combined <- combined[,list(count=sum(count)),by=list(person_a, person_b)][order(count, decreasing = T)]
  combined
}

get_adj_matrix <- function(likes) {
  if(!is.data.table(likes)) {
    stop('Parameter likes must be a data.table')
  }
  
  names <- unique(c(likes$poster, likes$liker))
  
  matr <- matrix(apply(expand.grid(poster=names, liker=names), 1, function(pair) {
    count <- likes[poster == pair['poster'] & liker == pair['liker'], list(count)][[1]]
    if(length(count) == 0) {
      return(0)
    }
    count
  }), length(names))
  rownames(matr) <- names
  colnames(matr) <- names
  matr
}

