setwd("Z:\\Documents")
options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')
library(qdap)

load("preprocessed_sentences")

load("stopwords")
stopwords <- stopwords$stopword

preprocessed_sentences$sentence <- tolower(preprocessed_sentences$sentence)
preprocessed_sentences$sentence <- removePunctuation(preprocessed_sentences$sentence)
preprocessed_sentences$sentence <- removeWords(preprocessed_sentences$sentence, stopwords)
preprocessed_sentences$sentence <- removeNumbers(preprocessed_sentences$sentence)
preprocessed_sentences$sentence <- stripWhitespace(preprocessed_sentences$sentence)

#save(preprocessed_sentences, file = "TI_data_by_sentence_stopwordsremoved")

frame <- data.frame(doc_id = preprocessed_sentences$doc_id, text = preprocessed_sentences$sentence,
                    score = preprocessed_sentences$score, date = preprocessed_sentences$date)


unigrams <- c("room", "staff", "check", "location", "casino", "pool", "bed", "food", "view",
              "restaurant", "show", "bathroom", "buffet")

bigrams <- c("resort fee", "front desk", "pool area", 
  "customer service", "coffee maker", "room service", "coffee shop")

bigrams_oneword <- c("resortfee", "frontdesk", "poolarea", 
               "customerservice", "coffeemaker", "roomservice", "coffeeshop")

frame$text <- mgsub(bigrams, bigrams_oneword, frame$text)

corpus <- VCorpus(DataframeSource(frame))

tdm <- TermDocumentMatrix(corpus)

single_words <- findAssocs(tdm, unigrams, .11)
single_words <- as.data.frame(single_words)
single_words$terms <- row.names(single_words)
single_words$terms <- factor(single_words$terms, levels= single_words$terms)
single_words

#write.xlsx(single_words$restaurant,"restaurant_assocs.xlsx")
#write.xlsx(single_words$show, "show_assocs.xlsx")
#write.xlsx(single_words$bathroom, "bathroom_assocs.xlsx")
#write.xlsx(single_words$buffet, "buffet_assocs.xlsx")
#single_words


double_words <- findAssocs(tdm, bigrams_oneword, .10)
double_words <- as.data.frame(double_words)
double_words$terms <- row.names(double_words)
double_words$terms <- factor(double_words$terms, levels= double_words$terms)
double_words


test_data <- data.frame(doc_id = 1:3, text = c("johnny was a hero",
                                               "he liked to rock",
                                               "johnny was a legend"))
test_corpus <- VCorpus(DataframeSource(test_data))
test_tdm <- TermDocumentMatrix(test_corpus)
as.matrix((test_tdm))

associations <- findAssocs(test_tdm, 'johnny', .05)
associations <- as.data.frame(associations)
associations$terms <- row.names(associations)
associations$terms <- factor(associations$terms, levels= associations$terms)
associations



