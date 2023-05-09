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
  select(1:2, CFR, everything())

# Large data frame into 4 smallers
n <- ncol(new_combined_2021) - 4
k <- 4
cols_per_dataset <- ceiling(n / k)
datasets <- list()

for (i in seq_len(k)) {
  start_col <- (i - 1) * cols_per_dataset + 5
  end_col <- min(i * cols_per_dataset + 4, 
                 ncol(new_combined_2021))
  datasets[[i]] <- cbind(new_combined_2021[, 1:4], 
                         new_combined_2021[, start_col:end_col])
}
quarter_1 <- datasets[[1]]
quarter_2 <- datasets[[2]]
quarter_3 <- datasets[[3]]
quarter_4 <- datasets[[4]]

# Stepwise regression models

fit_1 <- lm(CFR ~ ., data = quarter_1)
fit_2 <- lm(CFR ~ ., data = quarter_2)
fit_3 <- lm(CFR ~ ., data = quarter_3)
fit_4 <- lm(CFR ~ ., data = quarter_4)

step_1 <- step(fit_1)
step_2 <- step(fit_2)
step_3 <- step(fit_3)
step_4 <- step(fit_4)

step_1
step_2
step_3
step_4

# Best subset regression models
bs_1 <- regsubsets(data = quarter_1, 
                   CFR ~ ., 
                   nbest = 1, 
                   nvmax = NULL, 
                   force.in = NULL, force.out = NULL, 
                   method = "exhaustive", 
                   really.big = T)
summary_bs_1 <- summary(bs_1)
as.data.frame(summary_bs_1$outmat)
numb_predictors_1 <- which.max(summary_bs_1$adjr2)
summary_bs_1$which[numb_predictors_1,]

bs_2 <- regsubsets(data = quarter_2, 
                   CFR ~ ., 
                   nbest = 1, 
                   nvmax = NULL, 
                   force.in = NULL, force.out = NULL, 
                   method = "exhaustive", 
                   really.big = T)
summary_bs_2 <- summary(bs_2)
as.data.frame(summary_bs_2$outmat)
numb_predictors_2 <- which.max(summary_bs_2$adjr2)
summary_bs_2$which[numb_predictors_2,]

bs_3 <- regsubsets(data = quarter_3, 
                   CFR ~ ., 
                   nbest = 1, 
                   nvmax = NULL, 
                   force.in = NULL, force.out = NULL, 
                   method = "exhaustive", 
                   really.big = T)
summary_bs_3 <- summary(bs_3)
as.data.frame(summary_bs_3$outmat)
numb_predictors_3 <- which.max(summary_bs_3$adjr2)
summary_bs_3$which[numb_predictors_3,]

bs_4 <- regsubsets(data = quarter_4, 
                   CFR ~ ., 
                   nbest = 1, 
                   nvmax = NULL, 
                   force.in = NULL, force.out = NULL, 
                   method = "exhaustive", 
                   really.big = T)
summary_bs_4 <- summary(bs_4)
as.data.frame(summary_bs_4$outmat)
numb_predictors_4 <- which.max(summary_bs_4$adjr2)
summary_bs_4$which[numb_predictors_4,]