setwd("Z:\\Documents")
options(stringsAsFactors=F)
Sys.setlocale('LC_ALL','C')

load("TI_data_by_reviews_preprocessed_for_sentiment")

#install.packages("tidyverse")
library(tidyverse)
#install.packages("ggthemes")
library(ggthemes)
#install.packages("lubridate")
library(lubridate)
library(ggplot2)
library(sentimentr)


mean(nchar(TI_data_preprocessed$text))
mean(TI_data_preprocessed$score)

#TI_data_preprocessed$score <- as.integer(TI_data_preprocessed$score)
gradecounts <- count(TI_data_preprocessed,score)

# monthly sample size is too small in beginning and end of data set, cropping a few months
TI_data_preprocessed <- TI_data_preprocessed %>% filter(date >= "2016-06-01" & date <= "2018-12-31")

TI_data_preprocessed$sentiment <- sentiment(TI_data_preprocessed$text)$sentiment

datedata <- TI_data_preprocessed %>%
  group_by(date) %>%
  summarise(count = n(), scoresum = sum(score), sentimentsum = sum(sentiment))

datedata_by_month <- datedata %>% 
  group_by(month=floor_date(date, "month")) %>%
  summarize(meangrade = sum(scoresum)/sum(count), meansentiment = sum(sentimentsum)/sum(count))

gradeplot <- ggplot(datedata_by_month, aes(x = month, y = meangrade))+
  geom_line()+
  scale_x_date(breaks = datedata_by_month$month, labels = format(as.Date(datedata_by_month$month), "%Y-%m"))+
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))+
  ggtitle("Average review score by month")+
  xlab("Year and month of review")+
  theme(plot.title = element_text(hjust = 0.5))

sentiplot <- ggplot(datedata_by_month, aes(x = month, y = meansentiment))+
  geom_line()+
  scale_x_date(breaks = datedata_by_month$month, labels = format(as.Date(datedata_by_month$month), "%Y-%m"))+
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))+
  ggtitle("Average review sentiment by month")+
  xlab("Year and month of review")+
  theme(plot.title = element_text(hjust = 0.5))

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

multiplot(gradeplot, sentiplot, cols = 2)









