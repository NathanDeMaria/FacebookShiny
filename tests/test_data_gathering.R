
source('../R/data_gathering.R')

context('JSON Cleaning')

test_that('Shrug test', {
  
  original <- '{\"id\":\"742138635846285\",\"from\":{\"id\":\"744688009\",\"name\":\"Brendan Smith\"},\"message\":\"Just took 6cr this summer (two philosophy classes, both required for CS...). But yeah, none of my credit from high school counts, so maybe I can get all that removed. I\'ll have 102cr after this semester shrug\",\"can_remove\":false,\"created_time\":\"2014-08-15T01:11:50+0000\",\"like_count\":0,\"user_likes\":false}'
  
  cleaned <- clean_json(original)

  parsed <- fromJSON(cleaned)

  expect_is(parsed, 'list')
})

# you should find Ryan's thing too


