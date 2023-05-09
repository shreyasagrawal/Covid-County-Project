# Package prep
require(tidyr)
require(dplyr)
require(tibble)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)
require(leaps)
require(lubridate)
library(corrplot)

# Data prep
new_combined_2021 <- read_csv("https://www.dropbox.com/s/nolym5vik4je3yu/final_merged_data.csv?dl=1")

new_combined_2021 <- new_combined_2021 %>% 
  select(1:3, CFR, everything())

new_combined_2021$cases <- NULL
new_combined_2021$deaths <- NULL
new_combined_2021 <- new_combined_2021[, -c(8:11)]

df_nw <- new_combined_2021
df_nw$white <- NULL # white variable is excluded in df_nw
View(df_nw)

# Splitting into four smaller data frames
# Determine the number of splits and the size of each split
ncol(df_nw)
constant <- df_nw[3:3]
half_1 <- df_nw[4:17]
half_2 <- df_nw[18:38]
half_1 <- cbind(constant, half_1)
half_2 <- cbind(constant, half_2)

par(mar=c(1,1,1,1))
pairs(half_1)
pairs(half_2)