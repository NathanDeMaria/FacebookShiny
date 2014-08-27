
require(data.table)

app_settings <- fread('../data/secrets.csv')
setkey(app_settings, 'keys')