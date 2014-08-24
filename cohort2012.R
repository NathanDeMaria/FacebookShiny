# This is icky.  I'm gonna make some of it into functions, inputs from shiny app :)


# packages ####
library(RCurl)
library(rjson)
library(lubridate)
library(stringr)
library(ggvis)
library(data.table)

#setwd('R/') # doing this temporarily I swear
source('parsing.R')
source('data_gathering.R')
source('scoring.R')
source('visualize.R')
source('likes.R')

# needed for SSL stuff using curl on Windows
if(!file.exists('../cacert.pem')) {
  download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="../cacert.pem")
}

# getting data ####
#https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.0
token <- 'CAACEdEose0cBAMeZCLChAGWZAVIpVtgz5cC87b2dJIQKnxQmRJCIqr9ouAaF0fpZBZC8CWmcWeBATZBwWXWWdWvPXxlKS5WdDlcE6TNMBi81QOEZBJiRZBCbBXD7p8Noy3iIlJsnIKbu7ZB2AxLMOJxKWxeprKPecuw8QaV6kbZChwWCGQYzuX8k04NNQ9FWZCT4YZA2W02ANLe0W2aYoXfqZABo'

post_list <- get_json(token = token, pages_back = 2)
post_data <- posts_to_dt(post_list)

likes <- likes_to_dt(post_list)

like_counts <- likes[,list(count=length(post_id)),by=list(poster, liker)][order(count)]

# so there's only one link in a pair
first <- like_counts[liker < poster]
second <- like_counts[liker >= poster]
setnames(second, c('liker', 'poster', 'count'))
combined <- rbindlist(list(first, second))
combined <- combined[,list(count=sum(count)),by=list(poster, liker)][order(count)]

like_json <- d3_force_likes(data.table(combined))

#writeLines(like_json, con='/usr/share/nginx/html/facebook/likes.json')


