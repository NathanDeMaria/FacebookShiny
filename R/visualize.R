# Visualize ####
require(ggvis)

plot_time <- function(post_data) {
  # is it better like this or grouped by day?
  time_vis <- post_data %>% ggvis(~created_time, ~score) %>% 
      layer_points(opacity:=.2)
  time_vis
}

plot_averages <- function(post_data) {
  person_avg <- post_data[,list(score=mean(score)),by='poster'] 
  person_avg %>% ggvis(~poster, ~score) %>% layer_bars(stat='identity') %>% 
    add_axis("x", title='', properties = axis_props(
      labels = list(angle = 90, align = "left"))) %>% 
    add_axis('y', title='Sentiment') %>%
    scale_numeric("y", domain = c(min(person_avg$score) - 1, max(person_avg$score)))
}

plot_sums <- function(post_data) {
  person_sum <- post_data[,list(score=sum(score)),by='poster']
  person_sum %>% ggvis(~poster, ~score) %>% layer_bars(stat='identity') %>% 
    add_axis("x", title='', properties = axis_props(
      labels = list(angle = 90, align = "left"))) %>% 
    add_axis('y', title='Sentiment') %>%
    scale_numeric("y", domain = c(min(person_sum$score) - 1, max(person_sum$score)))
}

plot_time_hist <- function(post_data) {
  post_data %>% ggvis(~created_time)
}


