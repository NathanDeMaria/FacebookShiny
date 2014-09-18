
# packages ####
library(RJSONIO)
library(lubridate)
library(stringr)
library(ggvis)
library(data.table)
library(httr)

source('../R/parsing.R')
source('../R/data_gathering.R')
source('../R/scoring.R')
source('../R/visualize.R')
source('../R/likes.R')
source('../R/appSettings.R')
source('../R/reshaping_tables.R')

create_d3 <- function(like_counts) {
  d3 <- paste0(readLines('www/d3Section.html'), collapse='\n')
  
  gsub('d3_data', d3_force_likes(like_counts), d3)
}
