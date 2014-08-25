
source('../R/visualize.R')

context('Visualization')

# mostly just a smoke test
test_that('Visualizations make ggvis', {
  
  post_data <- data.table(poster = c('Cassey Lottman', 'Cassey Lottman', 'Trevor Poppen'), 
                          message = c('', 'I hate Rails', 'Its funny'),
                          created_time = c(as.POSIXct('2014/04/24'),as.POSIXct('2014/04/24'),as.POSIXct('2014/04/24')),
                          likes = c(1,2,3),
                          comments = c(2,3,4),
                          score=c(3,4,5))
  
  time_plot <- plot_time(post_data)
  sums_plot <- plot_sums(post_data)
  averages_plot <- plot_averages(post_data)
  
  expect_is(time_plot, 'ggvis')
  expect_is(sums_plot, 'ggvis')
  expect_is(averages_plot, 'ggvis')
})

