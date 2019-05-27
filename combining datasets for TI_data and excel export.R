load("~/TIpart1.Rda")
load("~/TIpart2.Rda")
load("~/TIpart3.Rda")
load("~/TIpart4.Rda")
TI_data <- rbind(treasure_island_data_part1, treasure_island_data_part2)
TI_data <- rbind(TI_data, treasure_island_data_part3)
TI_data <- rbind(TI_data, treasure_island_data_part4)
TI_data <- rbind(TI_data, treasure_island_data_part5_1)

save(TI_data, file="TI_data.Rda")
library(xlsx)
write.xlsx(TI_data, file="C:\\Users\\ollik\\Desktop\\Thesis2\\TI_data.xlsx")

