
source('../R/scoring.R')

context('Scoring')

test_that('Basic score', {
  
  dt <- data.table(messages='hello')
  
  dt[,score:=score_text(messages)]
  
  expect_is(dt, 'data.table')
  expect_is(dt$score, 'numeric')
})
