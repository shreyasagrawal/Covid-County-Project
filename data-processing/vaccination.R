# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)

# https://data.cdc.gov/Vaccinations/COVID-19-Vaccinations-in-the-United-States-County/8xkx-amqh
us.vaccination <- read_csv("https://www.dropbox.com/s/87vdc7kjvkqa6ca/COVID-19_Vaccinations_in_the_United_States_County.csv?dl=1")

colnames(us.vaccination)[1:2] <- c("date", "fips")
us.vaccination <- us.vaccination[!is.na(us.vaccination$fips), ]

us.vaccination$fips <- as.integer(us.vaccination$fips)