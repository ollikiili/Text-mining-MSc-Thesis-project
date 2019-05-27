setwd("Z:\\Documents")
options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')

#load data without sentence tokenization
load("TI_data_preprocessed")

#lemmatization
TI_data_preprocessed$text <- lemmatize_strings(TI_data_preprocessed$text)

load("stopwords")
stopwords <- stopwords$stopword

TI_data_preprocessed$text <- removePunctuation(TI_data_preprocessed$text)
TI_data_preprocessed$text <- stripWhitespace(TI_data_preprocessed$text)

save(TI_data_preprocessed, file = "TI_data_by_reviews_preprocessed_for_sentiment")

TI_data_preprocessed$text <- removeWords(TI_data_preprocessed$text, stopwords)
save(TI_data_preprocessed, file = "TI_data_by_reviews_preprocessed")