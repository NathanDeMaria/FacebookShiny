
require(data.table)

if(file.exists('data/secrets.csv')) {
  
  app_settings <- fread('data/secrets.csv')
} else {
  app_settings <- data.table(keys = c('cohort_page', 'api_token'), values = c('',''))
}
setkey(app_settings, 'keys')