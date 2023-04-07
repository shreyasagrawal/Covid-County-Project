# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)

# Data prep
demographic.2019 <- read.csv("https://github.com/shreyasagrawal/Covid-County-Project/blob/main/data/demographic-and-housing-estimate/demographic-and-housing-estimate-2019.csv?raw=true")
demographic.2020 <- read.csv("https://github.com/shreyasagrawal/Covid-County-Project/blob/main/data/demographic-and-housing-estimate/demographic-and-housing-estimate-2020.csv?raw=true")
demographic.2021 <- read.csv("https://github.com/shreyasagrawal/Covid-County-Project/blob/main/data/demographic-and-housing-estimate/demographic-and-housing-estimate-2021.csv?raw=true")

# Add YEAR variable for each dataset
demographic.2019$YEAR <- 2019
demographic.2020$YEAR <- 2020
demographic.2021$YEAR <- 2021

# Combine all sets by rows
demographic.all <- rbind(demographic.2019, 
                         demographic.2020, 
                         demographic.2021)
