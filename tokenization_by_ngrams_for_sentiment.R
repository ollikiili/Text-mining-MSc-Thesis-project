setwd("Z:\\Documents")

options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')

#install.packages("tidyverse")
library(tidyverse)
#install.packages("tm")
library(tm)
library(tidytext)
library(ggplot2)
library(ggthemes)
load("preprocessed_sentences")

#common stopwords from tm-package's library
stopwords <- tibble(stopword = stopwords())
stopwords_no_apostrophes <- tibble(stopword = gsub("'", "", stopwords$stopword))
stopwords <- full_join(stopwords, stopwords_no_apostrophes)

domain_specific_stopwords <- tibble(stopword = c("hotel", "strip", "get", "island", "treasure", "just", "will", "vega", "one",
                                                "time", "stay", "hotels", "also", "stay",
                                                 "1", "2", "3", "come", "go", "back", "ti", "us",
                                                "day", "night"))

stopwords <- full_join(stopwords, domain_specific_stopwords)
#save(stopwords, file = "stopwords_sentiment_analysis")

#single words = unigrams
tokenized_words <- preprocessed_sentences %>%
  unnest_tokens(word, sentence, token = "words", drop = F, collapse = F)

#tokenized_words <- tokenized_words %>%
#  anti_join(stopwords, by = c("word" = "stopword"))

tokenized_words <- tokenized_words %>% 
  select(-sentence,sentence)

save(tokenized_words, file = "tokenized_words_for_sentiment")


#bigrams
bigrams <- preprocessed_sentences %>%
  unnest_tokens(bigram, sentence, token = "ngrams", n = 2, drop = F, collapse = F)

bigrams <- bigrams %>% 
  select(-sentence,sentence)

bigrams_separated <- bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stopwords$stopword) %>%
  filter(!word2 %in% stopwords$stopword) %>%
  filter(!is.na(word1) | !is.na(word2))

tokenized_bigrams <- bigrams_filtered %>% 
  unite(bigram, word1, word2, sep = " ")

save(tokenized_bigrams, file = "tokenized_bigrams_for_sentiment")
