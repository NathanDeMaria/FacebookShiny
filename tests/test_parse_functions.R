setwd('../app')
source('R/parsing.R')

# Parse Comment test ####
context('Parse comment')

test_that('Typical comment', {
  
  comment <- list(
      id='741791112547704',
      from=list(id='1386256159', name='Tracy Moody'),
      message='Yes. This is what I do at 2am.',
      can_remove=F,
      created_time='2014-08-14T06:57:55+0000',
      like_count=1,
      user_likes=F
    )
  
  result <- parse_comment(comment)
  
  expect_is(result, 'data.frame')
  expect_equal(result$poster, 'Tracy Moody')
  expect_equal(result$message, 'Yes. This is what I do at 2am.')
  expect_equal(result$created_time, '2014-08-14T06:57:55+0000')
  expect_equal(result$likes, 1)
  expect_equal(result$comments, 0)
})
# are there any other cases that get passed to this function?

# Parse Post test ####
context('Parse post')

test_that('No comment no like post', {
  
  post <- list(
      id='370400073020145_741790912547724',
      from=list(id='1386256159', name='Tracy Moody'),
      to=list(data=list(name='Raikes Cohort 2012', id='370400073020145')),
      message="I just signed up for FITN 160",
      actions=list(list(name='Comment', link='https://www.facebook.com/370400073020145/posts/741790912547724'),
                   list(name='Like', link='https://www.facebook.com/370400073020145/posts/741790912547724')),
      privacy=list(value=''),
      type='status',
      application=list(name='Facebook for Android', namespace='fbandroid', id='350685531728'),
      created_time='2014-08-14T06:57:01+0000',
      updated_time='2014-08-14T20:35:10+0000'
    )
  
  result <- get_text(post)
  
  expect_is(result, 'data.frame')
  expect_equal(result$poster, 'Tracy Moody')
  expect_equal(result$message, 'I just signed up for FITN 160')
  expect_equal(result$created_time, '2014-08-14T06:57:01+0000')
  expect_equal(result$likes, 0)
  expect_equal(result$comments, 0)
})

test_that('Post from vector', {
  
  post <- list(
    id='370400073020145_741790912547724',
    
    # sometimes, this comes in as a character vector instead of a list?
    from=c(id='1386256159', name='Tracy Moody'),
    to=list(data=list(name='Raikes Cohort 2012', id='370400073020145')),
    message="I just signed up for FITN 160",
    actions=list(list(name='Comment', link='https://www.facebook.com/370400073020145/posts/741790912547724'),
                 list(name='Like', link='https://www.facebook.com/370400073020145/posts/741790912547724')),
    privacy=list(value=''),
    type='status',
    application=list(name='Facebook for Android', namespace='fbandroid', id='350685531728'),
    created_time='2014-08-14T06:57:01+0000',
    updated_time='2014-08-14T20:35:10+0000'
  )
  
  result <- get_text(post)
  
  expect_is(result, 'data.frame')
  expect_equal(result$poster, 'Tracy Moody')
  expect_equal(result$message, 'I just signed up for FITN 160')
  expect_equal(result$created_time, '2014-08-14T06:57:01+0000')
  expect_equal(result$likes, 0)
  expect_equal(result$comments, 0)
})

test_that('Post with likes', {
  
  post <- list(
    id='370400073020145_741790912547724',
    from=list(id='1386256159', name='Tracy Moody'),
    to=list(data=list(name='Raikes Cohort 2012', id='370400073020145')),
    message="I just signed up for FITN 160",
    actions=list(list(name='Comment', link='https://www.facebook.com/370400073020145/posts/741790912547724'),
                 list(name='Like', link='https://www.facebook.com/370400073020145/posts/741790912547724')),
    privacy=list(value=''),
    type='status',
    application=list(name='Facebook for Android', namespace='fbandroid', id='350685531728'),
    created_time='2014-08-14T06:57:01+0000',
    updated_time='2014-08-14T20:35:10+0000',
    likes=list(data=list(list(id='10203367306642831', name='Rachael Ann Dahlman')), 
               paging=list(cursors=list(after='MTAyMDMzNjczMDY2NDI4MzE=',
                                        before='MTAyMDMzNjczMDY2NDI4MzE=')))
  )
  
  result <- get_text(post)
  
  expect_is(result, 'data.frame')
  expect_equal(result$poster, 'Tracy Moody')
  expect_equal(result$message, 'I just signed up for FITN 160')
  expect_equal(result$created_time, '2014-08-14T06:57:01+0000')
  expect_equal(result$likes, 1)
  expect_equal(result$comments, 0)
})

test_that('Post with comments', {
  
  post <- list(
    id='370400073020145_741790912547724',
    from=list(id='1386256159', name='Tracy Moody'),
    to=list(data=list(name='Raikes Cohort 2012', id='370400073020145')),
    message="I just signed up for FITN 160",
    actions=list(list(name='Comment', link='https://www.facebook.com/370400073020145/posts/741790912547724'),
                 list(name='Like', link='https://www.facebook.com/370400073020145/posts/741790912547724')),
    privacy=list(value=''),
    type='status',
    application=list(name='Facebook for Android', namespace='fbandroid', id='350685531728'),
    created_time='2014-08-14T06:57:01+0000',
    updated_time='2014-08-14T20:35:10+0000',
    comments=list(data=list(list(id='741791112547704', 
                                 from=list(id='1386256159', name='Tracy Moody'),
                                 message='Yes. This is what I do at 2am.', 
                                 can_remove=F, 
                                 created_time='2014-08-14T06:57:55+0000', 
                                 like_count=1, 
                                 user_likes=F),
                            list(id='741939695866179', 
                                 from=list(id='10203367306642831', name='Rachael Ann Dahlman'),
                                 message='My certification for all that jazz did just recently expire', 
                                 can_remove=F, 
                                 created_time='2014-08-14T14:22:58+0000', 
                                 like_count=0, 
                                 user_likes=F)),
                  paging=list(cursors=list(after='', before='')))
  )
  
  result <- get_text(post)
  
  expect_is(result, 'data.frame')
  expect_equal(result$poster[1], 'Tracy Moody')
  expect_equal(result$message[1], 'I just signed up for FITN 160')
  expect_equal(result$created_time[1], '2014-08-14T06:57:01+0000')
  expect_equal(result$likes[1], 0)
  expect_equal(result$comments[1], 2)
  
  expect_equal(result$poster[2], 'Tracy Moody')
  expect_equal(result$likes[2], 1)
  expect_equal(result$comments[2], 0)
  
  expect_equal(result$poster[3], 'Rachael Ann Dahlman')
  expect_equal(result$likes[3], 0)
  expect_equal(result$comments[3], 0)
})

test_that('Post with NULL message', {
  
  post <- list(
    id='370400073020145_741790912547724',
    from=list(id='1386256159', name='Tracy Moody'),
    to=list(data=list(name='Raikes Cohort 2012', id='370400073020145')),
    actions=list(list(name='Comment', link='https://www.facebook.com/370400073020145/posts/741790912547724'),
                 list(name='Like', link='https://www.facebook.com/370400073020145/posts/741790912547724')),
    privacy=list(value=''),
    type='status',
    application=list(name='Facebook for Android', namespace='fbandroid', id='350685531728'),
    created_time='2014-08-14T06:57:01+0000',
    updated_time='2014-08-14T20:35:10+0000'
  )
  
  result <- get_text(post)
  
  expect_is(result, 'data.frame')
  expect_equal(result$poster[1], 'Tracy Moody')
  expect_equal(result$message[1], '')
  expect_equal(result$created_time[1], '2014-08-14T06:57:01+0000')
  expect_equal(result$likes[1], 0)
  expect_equal(result$comments[1], 0)
})



