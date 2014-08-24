
# packages ####
library(RCurl)
library(rjson)
library(lubridate)
library(stringr)
library(ggvis)
library(data.table)

source('../R/parsing.R')
source('../R/data_gathering.R')
source('../R/scoring.R')
source('../R/visualize.R')
source('../R/likes.R')

# needed for SSL stuff using curl on Windows
if(!file.exists('../cacert.pem')) {
  download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="../cacert.pem")
}

