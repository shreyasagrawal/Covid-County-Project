# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)
require(stringr)

# Data prep
places.2020 <- read_csv("https://www.dropbox.com/s/6p43l8phzm1qj85/County%20Data%20%28GIS%20Friendly%20Format%29%2C%202020%20release.csv?dl=1")
places.2021 <- read_csv("https://www.dropbox.com/s/o2t8n606trxska6/County%20Data%20%28GIS%20Friendly%20Format%29%2C%202021%20release.csv?dl=1")
places.2022 <- read_csv("https://www.dropbox.com/s/27en8ytece1d3vd/County%20Data%20%28GIS%20Friendly%20Format%29%2C%202022%20release.csv?dl=1")

# PLACES data cleaning & merging

# clean 2020 data
cleanplaces_20 <- places_2020 %>%
  select(-ends_with(c("95CI", "CrudePrev"))) %>%
  select(-StateDesc, -TotalPopulation, -Geolocation) %>% # -StateAbbr, -CountyName
  rename("fips" = "CountyFIPS") %>%
  rename_with(~str_remove(., "_AdjPrev")) %>%
  rename_all(., .funs = tolower) %>%
  slice(rep(1:n(), 52)) %>%
  mutate(year = 2020,
         week = rep(1:52, each = 3142))

# clean 2021 data
cleanplaces_21 <- places_2021 %>%
  select(-ends_with(c("95CI", "CrudePrev"))) %>%
  select(-StateDesc, -TotalPopulation, -Geolocation) %>% # -StateAbbr, -CountyName
  rename("fips" = "CountyFIPS") %>%
  rename_with(~str_remove(., "_AdjPrev")) %>%
  rename_all(., .funs = tolower) %>%
  slice(rep(1:n(), 52)) %>%
  mutate(year = 2021,
         week = rep(1:52, each = 3142))

# clean 2022 data
cleanplaces_22 <- places_2022 %>%
  select(-ends_with(c("95CI", "CrudePrev"))) %>%
  select(-StateDesc, -TotalPopulation, -Geolocation) %>% # -StateAbbr, -CountyName
  rename("fips" = "CountyFIPS") %>%
  rename_with(~str_remove(., "_AdjPrev")) %>%
  rename_all(., .funs = tolower) %>%
  slice(rep(1:n(), 52)) %>%
  mutate(year = 2022,
         week = rep(1:52, each = 3143))

# merge 2020 and 2021 data
places_20_21 <- full_join(cleanplaces_20, cleanplaces_21)

# remove missing values
places_20_21 <- places_20_21 %>%
  filter(!countyname %in% c("Copper River", "Chugach", "Valdez-Cordova")) %>%
  filter(stateabbr != "NJ") %>%
  select(-depression, -ghlth)

# merge 2020, 2021, and 2022 data
places_20_21_22 <- full_join(places_20_21, cleanplaces_22)

# remove missing values
places_20_21_22 <- places_20_21_22 %>%
  filter(!countyname %in% c("Copper River", "Chugach", "Valdez-Cordova")) %>%
  filter(stateabbr != "NJ") %>%
  select(-depression, -ghlth)

# places_20_21[!complete.cases(places_20_21), ] check for missing values
# places_20_21_22[!complete.cases(places_20_21_22), ] check for missing values
```
