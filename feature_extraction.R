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

domain_specific_stopwords <- tibble(stopword = c("hotel", "strip", "get", "island", "treasure", "just", "will", "vega", "nice", "great", "one", "like",
                  "comfortable", "friendly", "time", "good", "stay", "free", "hotels", "also", "overall", "also", "stay",
                  "clean","everything", "1", "2", "3", "come", "go", "back", "much", "ti", "need", "close", "us",
                  "can", "day", "close", "night"))

stopwords <- full_join(stopwords, domain_specific_stopwords)
#save(stopwords, file = "stopwords_feature_extraction")

#single words = unigrams
tokenized_words <- preprocessed_sentences %>%
  unnest_tokens(word, sentence, token = "words", drop = F, collapse = F)

tokenized_words <- tokenized_words %>%
  anti_join(stopwords, by = c("word" = "stopword"))

tokenized_words <- tokenized_words %>% 
  select(-sentence,sentence)

word_freqs <- tokenized_words %>%
  count(word, sort = T)

#write.xlsx(word_freqs, "unigram_excel.xlsx")

#save(tokenized_words, file = "tokenized_words")
#save(word_freqs, file = "unigram_frequencies")

print(word_freqs, n = 50)

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


bigram_counts <- tokenized_bigrams %>%
  count(bigram, sort = T)

#save(tokenized_bigrams, file = "tokenized_bigrams")
#save(bigram_counts, file = "bigram_frequencies")

number_of_reviews_in_dataset <- 9352
bigram_counts$support <- bigram_counts$n/number_of_reviews_in_dataset

# we only want those bigrams that are mentioned at least once per 100 reviews in dataset
top_bigrams <- filter(bigram_counts, support >= 0.01)

#write.xlsx(top_bigrams, "bigrams_excel.xlsx")

unigram_vector <- c("room", "staff", "check", "location", "casino", "pool", "bed", "food", "view",
           "restaurant", "show", "bathroom", "buffet")


## this needs not be manual like this!!!
unigram_counts <- c(6312, 2320, 1980, 1671, 1311, 1173, 1020, 830, 778, 749, 700, 470, 446)

bigram_vector <- c("resort fee", "front desk", "customer service", "coffee maker", "room service", "coffee shop")
bigram_counts <- c(562, 371, 156, 145, 143, 122)

unigram_data <- tibble(feature = unigram_vector, count = unigram_counts)
unigram_data <- unigram_data %>% arrange(desc(count))
bigram_data <- tibble(feature = bigram_vector, count = bigram_counts)

unigram_barchart <- ggplot(unigram_data, aes(x = reorder(feature, count), y = count,
                           label = count)) +
  geom_bar(stat = "identity") + 
  coord_flip() + labs(x = "feature", title = "Frequencies of single word features") +
  theme_economist() + 
  geom_text(size = 3, position = position_stack(vjust = 0.5))
  

bigram_barchart <- ggplot(bigram_data, aes(x = reorder(feature, count), y = count,
                                            label = count)) +
  geom_bar(stat = "identity") + 
  coord_flip() + labs(x = "feature", title = "Frequencies of two word features") +
  theme_economist() + 
  geom_text(size = 3, position = position_stack(vjust = 0.5))

