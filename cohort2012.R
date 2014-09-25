# This is icky.  I'm gonna make some of it into functions, inputs from shiny app :)


# packages ####
library(RJSONIO)
library(lubridate)
library(stringr)
library(ggvis)
library(data.table)
library(httr)

setwd('app/')
source('R/parsing.R')
source('R/data_gathering.R')
source('R/scoring.R')
source('R/visualize.R')
source('R/likes.R')
source('R/appSettings.R')
source('R/reshaping_tables.R')


# getting data ####
post_list <- get_json(token = app_settings['api_token','values',with=F][[1]], pages_back = 10, group_id = app_settings['cohort_page','values',with=F][[1]])
post_data <- posts_to_dt(post_list)

likes <- likes_to_dt(post_list)

like_counts <- likes[,list(count=length(post_id)),by=list(poster, liker)][order(count, decreasing = T)]

# so there's only one link in a pair
likes_by_person <- get_lbp(post_data)
like_counts[,like_rate:=count/likes_by_person[poster]$Posts]

likes_by_person <- get_lbp(post_data)
like_counts[,like_rate:=count/likes_by_person[poster]$Posts]
combined_likes <- combine_likes(like_counts)
like_json <- d3_force_likes(combined_likes)

