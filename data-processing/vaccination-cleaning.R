###########
# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)

# https://data.cdc.gov/Vaccinations/COVID-19-Vaccinations-in-the-United-States-County/8xkx-amqh
us.vaccination <- read_csv("https://www.dropbox.com/s/87vdc7kjvkqa6ca/COVID-19_Vaccinations_in_the_United_States_County.csv?dl=1")

#missing_data <- data.frame(variable = colnames(us.vaccination), 
#                           missing_percentage = 
#                             colMeans(is.na(us.vaccination)) * 100)
#write.csv(missing_data, file = "us_vaccination_missing_data.csv", row.names = FALSE)

us.vaccination <- us.vaccination %>% rename(collection_week = Date)

# Convert the "collection_week" column to a Date object
us.vaccination$collection_week <- as.Date(us.vaccination$collection_week, format = "%m/%d/%Y")

# Format the "collection_week" column to the desired format
us.vaccination$collection_week <- format(us.vaccination$collection_week, "%Y-%m-%d")

# Create year_number column
year_number <- strftime(us.vaccination$collection_week, 
                        format = "%Y")
us.vaccination$year_number <- year_number

# Create week_number column
week_number <- strftime(us.vaccination$collection_week, 
                        format = "%V")
us.vaccination$week_number <- week_number

# Keep these variables

us.vaccination <- us.vaccination[, c("collection_week","FIPS","MMWR_week", "Recip_County", "Recip_State","Completeness_pct","Administered_Dose1_Pop_Pct","Series_Complete_Pop_Pct", "Booster_Doses_Vax_Pct", "Series_Complete_Pop_Pct_SVI", "Booster_Doses_Vax_Pct_SVI", "week_number", "year_number")]
# Integrate rows with the same week_number, year_number, and fips_code
# Because all variables were counts, making integration by additions reasonable

library(dplyr)
us.vaccination <- us.vaccination %>% filter(year_number != 2021)
ushead <- head(us.vaccination,20000)
us.vaccination <- us.vaccination %>%
  group_by(week_number, FIPS) %>%
  summarise(Completeness_pct = mean(Completeness_pct),
          Administered_Dose1_Pop_Pct = mean(Administered_Dose1_Pop_Pct),
          Series_Complete_Pop_Pct = mean(Series_Complete_Pop_Pct),
          Booster_Doses_Vax_Pct = mean(Booster_Doses_Vax_Pct),
          Series_Complete_Pop_Pct_SVI = mean(Series_Complete_Pop_Pct_SVI))

us.vaccination <- us.vaccination %>% filter(week_number != 53)

# Change -999999.00 to N/A
# -999999.00 represents the suppression to the file for sums and averages less 
# than four, for which assuming it to be 0 will not be reasonable because we 
# may not know the actual value -999999.00 represents
us.vaccination[us.vaccination < 0] <- 0

write.csv(us.vaccination, "C://Users//daopomel//Downloads//us_vaccination_cleaned.csv", row.names = FALSE)

