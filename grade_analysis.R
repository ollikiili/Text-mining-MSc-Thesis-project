setwd("Z:\\Documents")

options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')


#apparently this file is not used so commented the load out
#load("TI_data_by_reviews_preprocessed")
load("tokenized_words")
load("tokenized_bigrams")

unigrams <- c("room", "staff", "check", "location", "casino", "pool", "bed", "food", "view",
              "restaurant", "show", "buffet")

bigrams <- c("resort fee", "front desk", "pool area", 
             "customer service", "coffee maker", "room service", "coffee shop")

unigram_data <- filter(tokenized_words, word %in% unigrams)
unigram_data <- unigram_data %>% select(-sentence)
unigram_data <- unigram_data %>% distinct()

unigram_grade_means <- tibble(unigrams = unigrams, mean = 0, difference = 0)

for (i in 1:length(unigrams)) {
  data <- filter(unigram_data, word == unigrams[i] )
  mean <- mean(data$score)
  unigram_grade_means$mean[i] = mean
  unigram_grade_means$difference[i] = mean - 8.09
}

unigram_grade_means

bigram_data <- filter(tokenized_bigrams, bigram %in% bigrams)
bigram_data <- bigram_data %>% select(-sentence)
bigram_data <- bigram_data %>% distinct()

bigram_grade_means <- tibble(bigrams = bigrams, mean = 0, difference = 0)

for (i in 1:length(bigrams)) {
  data <- filter(bigram_data, bigram == bigrams[i] )
  mean <- mean(data$score)
  bigram_grade_means$mean[i] = mean
  bigram_grade_means$difference[i] = mean - 8.09
}

bigram_grade_means

feature_grade_means <- tibble(feature = c(unigrams, bigrams), 
                              mean = c(unigram_grade_means$mean, bigram_grade_means$mean),
                              difference = c(unigram_grade_means$difference, bigram_grade_means$difference))
feature_grade_means <- arrange(feature_grade_means, desc(mean))

#write.xlsx(feature_grade_means, "mean_grades_excelV2.xlsx")

grade_barchart <- ggplot(feature_grade_means, aes(x = reorder(feature, difference), y = difference,
                                                                label = round(difference, digits = 2))) +
  geom_bar(stat = "identity") + 
  coord_flip() + labs(x = "feature", title = "Difference to mean of all reviews") +
  theme_economist() + 
  geom_text(size = 3, position = position_stack(vjust = 0.5))