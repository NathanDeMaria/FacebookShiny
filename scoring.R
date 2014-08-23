require(stringr)
require(data.table)

score_text <- function(text_data) {
    
  affin <- fread('/home/ubuntu/ConAgra/twitteR/AFINN-111.txt', colClasses=c('character', 'numeric'))
  setnames(affin, c('word', 'score'))
  setkey(affin, word)
  
  score_sentiment <- Vectorize(function(post) {
    # removes punctuation and stuff
    post <- gsub('[[:punct:]]', '', post)
    post <- gsub('[[:cntrl:]]', '', post)
    post <- gsub('\\d+', '', post)
    post <- iconv(post, 'ASCII', sub = "byte")
    # and convert to lower case:
    post <- tolower(post)
    
    # split into words
    words <- unlist(str_split(post, '\\s+'))
    
    # score the words
    sum(affin[words,]$score, na.rm=T)  
  }, USE.NAMES=F)
  
  score_sentiment(text_data)
}




