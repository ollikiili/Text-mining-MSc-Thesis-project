setwd("Z:\\Documents")
options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')

load("TI_data_preprocessed")

#install.packages("tidyverse")
library(tidyverse)
#install.packages("ggthemes")
library(ggthemes)
#install.packages("lubridate")
library(lubridate)


mean(nchar(TI_data_preprocessed$text))
mean(TI_data_preprocessed$score)

#TI_data_preprocessed$score <- as.integer(TI_data_preprocessed$score)
gradecounts <- count(TI_data_preprocessed,score)

gradedata <- TI_data_preprocessed %>%
  group_by(score) %>%
  summarise(count = n())

ggplot(gradedata, aes(x = score, y = count))+
  geom_bar(stat="identity")+
  geom_text(aes(label=count),vjust = -0.3)+
  scale_x_discrete(limits = c(2,4,6,8,10))+
  labs(x = "grade")+
  theme_economist()


datedata <- TI_data_preprocessed %>%
  group_by(date) %>%
  summarise(count = n())

datedata_by_month <- datedata %>% 
  group_by(month=floor_date(date, "month")) %>%
  summarize(count=sum(count))

ggplot(datedata_by_month, aes(x = month, y = count))+
  geom_line()+
  scale_x_date(breaks = datedata_by_month$month, labels = format(as.Date(datedata_by_month$month), "%Y-%m"))+
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))+
  ggtitle("Time distribution of review dataset")+
  xlab("Year and month of review")+
  theme(plot.title = element_text(hjust = 0.5))