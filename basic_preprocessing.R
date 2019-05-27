setwd("Z:\\Documents")

options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')

#install.packages("tidyverse")
library(tidyverse)

load("TI_data.Rda")

# The original data contains illegitimate characters such as nul strings, emojis etc.
# Conversion to ASCII fails for any review that contains these illegal characters
# and results in that review being assigned the value NA. 
TI_data$body <- iconv(TI_data$body, from = "UTF-8", to = "ASCII")

# We then reduce the dataset by removing all datapoints where the review has value NA.
# As a result, the dataset is reduced from n = 10000 to n = 9352.
# This is necessary to get the data into a format where we can work with it in R.
TI_data <- subset(TI_data, !is.na(body))

# We will also conduct a part of the analysis focusing on unsatisfied reviwers.
# TI_data <- subset(TI_data, TI_data$title < 6)
# TI_data <- subset(TI_data, TI_data$title >= 6)

# Each datapoint contains a review score from 2-10, a written review body and date of review.
# All data is originally in string format. First steps are to convert the scores to numerics
# and dates to a proper date format.

# Convert review scores to numeric
TI_data$title <- as.numeric(TI_data$title)

# convert dates to proper format
TI_data$date <- as.Date(TI_data$date, format='%B %d, %Y')

# add index to reach review
TI_data$doc_id <- seq.int(nrow(TI_data))


# some reordering and renaning of data for clarity
TI_data <- TI_data[c("doc_id","body","title","date")]
names(TI_data)[names(TI_data)=="body"] <- "text"
names(TI_data)[names(TI_data)=="title"] <- "score"

TI_data_preprocessed <- as_tibble(TI_data)
TI_data_preprocessed$text <- TI_data_preprocessed$text %>% tolower()


# spell checking
# take the first 1000 reviews for manual correction of spelling errors
# first_1000_revs <- TI_data_preprocessed %>%
# filter(doc_id <= 1000)

# correct spelling manually using Rinker's function
# spelling_correction <- check_spelling_interactive(first_1000_revs$sentence)

# save results of manual correcting to file to form correction template
# saveRDS(spelling_correction,"spellingcorrection.rds")

# correct spelling of entire corpus according to the correction template
spelling_rules <- readRDS("spellingcorrection.rds")
spelling_correct <- attributes(spelling_rules)$correct
TI_data_preprocessed$text <- TI_data_preprocessed$text %>%
  spelling_correct()

save(TI_data_preprocessed, file = "TI_data_preprocessed")
