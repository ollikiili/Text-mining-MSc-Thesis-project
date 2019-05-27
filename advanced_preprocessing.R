setwd("Z:\\Documents")
options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')


#install.packages("tidyverse")
library(tidyverse)
#install.packages("tidytext")
library(tidytext)
#install.packages("koRpus")
library(koRpus)
#install.packages("koRpus.lang.en")
library(koRpus.lang.en)
#install.packages("textstem")
library(textstem)
#install.packages("rJava")
library(rJava)
#install.packages("stringr")
library(stringr)
library(tm)

load("TI_data_preprocessed")

#tokenization to sentence level
data_by_sentences <- filter(TI_data_preprocessed, doc_id < 0)
data_by_sentences <- data_by_sentences %>% rename(sentence = text)


# this function simply assumes sentences are separated by dots
# sentences with less than 5 characters are ignored
for (i in 1:length(TI_data_preprocessed$doc_id)) {
  sentences <- str_split(TI_data_preprocessed$text[i], "\\.")[[1]]
  number_of_sentences <- length(sentences)
    for (j in 1:number_of_sentences) {
      if (nchar(sentences[j]) >= 5) {
        data_by_sentences <- data_by_sentences %>% add_row(
                doc_id = TI_data_preprocessed$doc_id[i],
                sentence = sentences[j],
                score = TI_data_preprocessed$score[i],
                date = TI_data_preprocessed$date[i]
        )
      }
    }
}

#save(data_by_sentences, file = "data_by_sentences")
#load("data_by_sentences")

data_by_sentences$sentence <-  gsub("'","",data_by_sentences$sentence)
data_by_sentences$sentence <-  gsub('"',"",data_by_sentences$sentence)
data_by_sentences$sentence <-  stripWhitespace(data_by_sentences$sentence)


#lemmatization
data_by_sentences$sentence <- lemmatize_strings(data_by_sentences$sentence)

#saving the results 
preprocessed_sentences <- data_by_sentences
rm(data_by_sentences)
save(preprocessed_sentences, file = "preprocessed_sentences")
