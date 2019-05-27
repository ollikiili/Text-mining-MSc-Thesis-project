setwd("Z:\\Documents")

#install.packages("sentimentr")
library(sentimentr)
library(ggplot2)
library(ggthemes)
library(tidyverse)

# get bigrams in sentences
load("tokenized_words_for_sentiment")
load("tokenized_bigrams_for_sentiment")

#test sentences
test_sentences <- c("very bad", "it was good", "murderous traitor", 
  "happy", "very happy", "not happy")

# single word features
unigrams <- c("room", "staff", "check", "location", "casino", "pool", "bed", "food", "view",
              "restaurant", "show", "buffet")

sentiment <- vector()

for (i in unigrams) {
  sentences <- filter(tokenized_words, word == i)
  senti <- sentiment_by(sentences$sentence)
  average_sentiment <- mean(senti$ave_sentiment)
  sentiment[i] <- average_sentiment
}

unigram_feature_sentiments <- tibble(unigrams, sentiment)
unigram_feature_sentiments <- arrange(unigram_feature_sentiments, desc(sentiment))
#write.xlsx(unigram_feature_sentiments, "unigram_sentiments.xlsx")
rm(sentiment)

unigram_sent_barchart <- ggplot(unigram_feature_sentiments, aes(x = reorder(unigrams, sentiment), y = sentiment,
                                             label = round(sentiment, digits = 2))) +
  geom_bar(stat = "identity") + 
  coord_flip() + labs(x = "feature", title = "Sentiments of single word features") +
  theme_economist() + 
  geom_text(size = 3, position = position_stack(vjust = 0.5))

#bigram features
bigrams <- c("resort fee", "front desk", "pool area", 
             "customer service", "coffee maker", "room service", "coffee shop")

sentiment <- vector()

for (i in bigrams) {
  sentences <- filter(tokenized_bigrams, bigram == i)
  senti <- sentiment_by(sentences$sentence)
  average_sentiment <- mean(senti$ave_sentiment)
  sentiment[i] <- average_sentiment
}

bigram_feature_sentiments <- tibble(bigrams, sentiment)
bigram_feature_sentiments <- arrange(bigram_feature_sentiments, desc(sentiment))
#write.xlsx(bigram_feature_sentiments, "bigram_sentiments.xlsx")

bigram_sent_barchart <- ggplot(bigram_feature_sentiments, aes(x = reorder(bigrams, sentiment), y = sentiment,
                                                                label = round(sentiment, digits = 2))) +
  geom_bar(stat = "identity") + 
  coord_flip() + labs(x = "feature", title = "Sentiments of two word features") +
  theme_economist() + 
  geom_text(size = 3, position = position_stack(vjust = 0.5))
       
       
# sentiment of entire dataset by review
load("TI_data_by_reviews_preprocessed_for_sentiment")
TI_data_preprocessed$sentiment <- sentiment(TI_data_preprocessed$text)$sentiment

