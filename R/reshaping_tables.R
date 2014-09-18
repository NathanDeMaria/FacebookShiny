
require(data.table)

get_lbp <- function(post_data) {
  lbp <- post_data[,list('Likes per post'=mean(likes), 
                  Posts=length(likes), 
                  'Total Likes'=sum(likes)), by='poster']
  
  setkey(lbp, 'poster')
  lbp
}