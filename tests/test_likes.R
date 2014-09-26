setwd('../app')
source('R/likes.R')

context('Adjacency matrix')

test_that('get_adj_matrix', {
  like_counts <- data.table(
      poster = c('Michael Hollman', 'Jimmy Lee'),
      liker = c('Tracy Moody', 'Rachael Ann Dahlman'),
      count = c(3, 4)
    )
  
  adj_mat <- get_adj_matrix(like_counts)
  
  expect_is(adj_mat, 'matrix')
  expect_equal(rownames(adj_mat), 
               c('Michael Hollman', 'Jimmy Lee', 
                 'Tracy Moody', 'Rachael Ann Dahlman'))
  expect_equal(colnames(adj_mat), 
               c('Michael Hollman', 'Jimmy Lee', 
                 'Tracy Moody', 'Rachael Ann Dahlman'))
  expect_equal(adj_mat[1,3], 3)
  expect_equal(adj_mat[2,4], 4)
  expect_equal(adj_mat[3,2], 0)
})
