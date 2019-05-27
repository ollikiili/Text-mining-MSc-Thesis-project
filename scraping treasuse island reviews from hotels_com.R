install.packages('rvest')
library(rvest)

#Master dataframe. Each page will be harvested separately, and results will be appended here.
treasure_island_data_1 <- data.frame(
  title = character(),
  body = character(),
  date = character(),
  stringsAsFactors = F
)

Sys.setlocale("LC_ALL", "English") 
# Harvesting each page
for (i in 1:250) {
 # url <- paste('https://www.hotels.com/ho134556-tr-p',i,'/?q-check-out=2019-02-16&roomno=1&rooms%5B0%5D.numberOfAdults=2&display=reviews&q-check-in=2019-02-15&reviewOrder=date_newest_first&tripTypeFilter=all', sep ="")
  url <- paste('https://uk.hotels.com/ho134556-tr-p',i,'/?q-check-in=2019-02-15&q-check-out=2019-02-16&q-rooms=1&q-room-0-adults=2&SYE=3&ZSX=0&MGT=1&YGF=1&WOD=5&WOE=6&JHR=2&FPQ=3', sep ="")
  webpage <- read_html(url)
  review_title <- html_nodes(webpage,'.review-score .rating')
  title_text <- html_text(review_title)
  review_body <- html_nodes(webpage,'.expandable-content')
  body_text <- html_text(review_body)
  review_date <- html_nodes(webpage,'.date')
  date_text <- html_text(review_date)
  page_data <- data.frame(title = title_text, body = body_text, date = date_text, stringsAsFactors = F)
  treasure_island_data_1 <- rbind(treasure_island_data_1, page_data)
}
save(treasure_island_data_1,file="TI1.Rda")

str(treasure_island_data)
str(page_data)