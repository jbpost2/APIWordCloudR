library(newsanchor)
library(tidytext)
library(stringr)
library(wordcloud2)
library(httpuv)
results <- get_headlines(category = "sports", api_key = "aa4b545bfbd64d4bb22ba0cb9f78189c", country = "us")
results2 <- get_headlines(category = "sports", api_key = "aa4b545bfbd64d4bb22ba0cb9f78189c", country = "us", page = 2)

dat <- results$results_df

mydata <- dat$description %>% as_tibble()

mydata %>% unnest_tokens(word, value) %>% anti_join(stop_words) %>% count(word, sort = TRUE)


dat$description %>% unnest_tokens(word, text) 
twitsTableCount <- twits %>% unnest_tokens(word, text) %>% anti_join(stop_words) %>% count(word, sort = TRUE) %>% filter(!(word %in% c("https", "t.co")))



library(dplyr)
library(janeaustenr)

d <- tibble(txt = prideprejudice)
d
d %>%
  unnest_tokens(word, txt)

aa4b545bfbd64d4bb22ba0cb9f78189c



### This is the end exmaple that made me think it is very easy and do-able
library(httr)
library(jsonlite)
mydata <- GET("http://newsapi.org/v2/everything?q=tesla&from=2021-01-01&sortBy=publishedAt&apiKey=aa4b545bfbd64d4bb22ba0cb9f78189c")

medata <- rawToChar(mydata$content)
dat <- fromJSON(medata)
str(dat$articles)
final <- dat$articles$description %>% as_tibble() %>%  unnest_tokens(word, value) %>% anti_join(stop_words) %>% count(word, sort = TRUE)
wordcloud2(final, size=0.7, minSize = 0.1)

str(medata)

mydata$content
mydata$request
