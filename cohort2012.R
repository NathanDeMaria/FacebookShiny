
#TODO: right now, sourcing this reads everything from Facebook twice
  # once for sentiment, and once for likes
  # that is dumb.
  # fix it.

# packages ####
library(RCurl)
library(rjson)
library(lubridate)
library(stringr)
library(ggvis)
library(dplyr)
library(data.table)

source('parsing.R')
source('data_gathering.R')
source('scoring.R')
source('visualize.R')
source('likes.R')

# getting data ####
#https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.0
token <- 'CAACEdEose0cBAMeZCLChAGWZAVIpVtgz5cC87b2dJIQKnxQmRJCIqr9ouAaF0fpZBZC8CWmcWeBATZBwWXWWdWvPXxlKS5WdDlcE6TNMBi81QOEZBJiRZBCbBXD7p8Noy3iIlJsnIKbu7ZB2AxLMOJxKWxeprKPecuw8QaV6kbZChwWCGQYzuX8k04NNQ9FWZCT4YZA2W02ANLe0W2aYoXfqZABo'

post_data <- get_all(token, 16)

post_data[,score:=score_text(message)]

likes <- get_likes(token, 16)

like_counts <- likes %>% 
  regroup(list('poster', 'liker')) %>% 
  summarise(count=length(poster)) %>% 
  arrange(count)

# so there's only one link in a pair
first <- like_counts %>% filter(liker < poster)
second <- like_counts %>% filter(liker >= poster)
setnames(second, c('liker', 'poster', 'count'))
combined <- rbind_list(first, second)
combined <- combined %>% 
  regroup(list('poster', 'liker')) %>% 
  summarise(count=sum(count)) %>% 
  arrange(count)

like_json <- d3_force_likes(data.table(combined))

writeLines(like_json, con='/usr/share/nginx/html/facebook/likes.json')


