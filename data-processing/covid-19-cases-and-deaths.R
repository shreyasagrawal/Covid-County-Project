# Package prep
require(tidyr)
require(dplyr)
require(tibble)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)

# Cases/deaths (counties) by time ----
us.counties.2020 <- read_csv("https://www.dropbox.com/s/a6c6m3b3jh5a172/us-counties-2020.csv?dl=1")
us.counties.2021 <- read_csv("https://www.dropbox.com/s/cnjkrvm6tlwwqup/us-counties-2021.csv?dl=1")
us.counties.2022 <- read_csv("https://www.dropbox.com/s/74ca13pn9c09kqt/us-counties-2022.csv?dl=1")
us.counties.2023 <- read_csv("https://www.dropbox.com/s/luff8kr8p2j7g5l/us-counties-2023.csv?dl=1")

# Combining all datasets above into a master set ----
us.counties.all <- rbind(us.counties.2020, us.counties.2021, 
                         us.counties.2022, us.counties.2023)
mydata <- us.counties.all

# Convert date to Date class
mydata$date <- as.Date(mydata$date)
class(mydata$date)

# Create year_number column
year_number <- strftime(mydata$date, format = "%Y")
mydata <- add_column(mydata, year_number, .after = 1)

# Create week_number column
week_number <- strftime(mydata$date, format = "%V")
mydata <- add_column(mydata, week_number, .after = 2)

# Calculate difference in cases/deaths for each states by time ----
mydata.sorted <- mydata %>% 
  group_by(fips) %>% 
  mutate(diff.cases = ifelse(fips == lag(fips), 
                       cases - lag(cases), NA)) %>% 
  mutate(diff.deaths = ifelse(fips == lag(fips), 
                              deaths - lag(deaths), NA))
View(mydata.sorted)

# Integrate rows with the same week_number, year_number, and fips_code
mydata %>% 
  group_by(year_number, week_number, fips) %>% 
  summarise_at(vars(cases, deaths), sum) %>% 
  ungroup()
View(mydata)