# Package prep
require(tidyr)
require(dplyr)
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
# View(us.counties.all)

# Calculate difference in cases/deaths for each states by time ----
counties.sorted <- us.counties.all %>% 
  group_by(county) %>% 
  mutate(diff.cases = ifelse(fips == lag(fips), 
                       cases - lag(cases), NA)) %>% 
  mutate(diff.deaths = ifelse(fips == lag(fips), 
                              deaths - lag(deaths), NA))
counties.sorted$date <- as.Date(counties.sorted$date, 
                                format = "%Y-%m-%d") 
View(counties.sorted)

# Considering daily cases/deaths changes were trivial
# Aggregate daily data into months ----
counties.monthly <- aggregate(diff.cases ~ fips + 
                                format(date, "%Y-%m"), 
                              data = counties.sorted, sum)
View(counties.monthly)

ggplot(counties.monthly, 
       mapping = aes(x = fips, y = diff.cases)) +
  geom_boxplot()