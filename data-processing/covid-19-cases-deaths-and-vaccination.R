# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)

# Master data from New York Times ----
## Cases/deaths (counties) by time ----
us.counties.2020 <- read_csv("https://www.dropbox.com/s/a6c6m3b3jh5a172/us-counties-2020.csv?dl=1")
us.counties.2021 <- read_csv("https://www.dropbox.com/s/cnjkrvm6tlwwqup/us-counties-2021.csv?dl=1")
us.counties.2022 <- read_csv("https://www.dropbox.com/s/74ca13pn9c09kqt/us-counties-2022.csv?dl=1")
us.counties.2023 <- read_csv("https://www.dropbox.com/s/luff8kr8p2j7g5l/us-counties-2023.csv?dl=1")

### Combining all datasets above into a master set ----
us.counties.all <- rbind(us.counties.2020, us.counties.2021, 
                         us.counties.2022, us.counties.2023)
# View(us.counties.all)

## Calculate difference in cases/deaths for each states by time ----
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
## Aggregate daily data into months ----
counties.monthly <- aggregate(diff.cases ~ fips + 
                                format(date, "%Y-%m"), 
                              data = counties.sorted, sum)
View(counties.monthly)

ggplot(counties.monthly, 
       mapping = aes(x = fips, y = diff.cases)) +
  geom_boxplot()

# COVID Vaccination data from CDC ----
# https://data.cdc.gov/Vaccinations/COVID-19-Vaccinations-in-the-United-States-County/8xkx-amqh
us.vaccination <- read_csv("https://www.dropbox.com/s/87vdc7kjvkqa6ca/COVID-19_Vaccinations_in_the_United_States_County.csv?dl=1")

## Data processing ----
colnames(us.vaccination)[1:2] <- c("date", "fips")
us.vaccination <- us.vaccination[!is.na(us.vaccination$fips), ]

us.vaccination$fips <- as.integer(us.vaccination$fips)

# Create master dataset ----
# master.us.covid <- merge(us.counties.all, 
#                          us.vaccination, 
#                          by = c("date", "fips"))
master.us.covid <- merge(us.counties.all, 
                                  us.vaccination, 
                                  by = c("date", "fips"), 
                              all = TRUE)
# View(master.us.covid)
master.us.covid <- master.us.covid[, !colnames(master.us.covid) %in%
                                     c("county", "state", 
                                     "Recip_County", "Recip_State")]

head(master.us.covid)

# Hospital Occupancy data from CDC ----
# Hospital capacity tracker: https://covid.cdc.gov/covid-data-tracker/#hospital-capacity

## Reported Patient Impact and Hospital Capacity by Facility ----
# COVID-19 Reported Patient Impact and Hospital Capacity by Facility: https://healthdata.gov/Hospital/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/anag-cw7u
# COVID-19 Reported Patient Impact and Hospital Capacity by Facility (data source): https://healthdata.gov/stories/s/nhgk-5gpv
patientImpact.hospitalCapacity <- read_csv("https://www.dropbox.com/s/fgb0ga3o84bfajp/covid-19_reported_patient_impact_and_hospital_capacity_by_facility.csv?dl=1")
View(patientImpact.hospitalCapacity)

# Other potential data sources ----

## Vaccine Hesitancy from CDC ----
# https://data.cdc.gov/Vaccinations/Vaccine-Hesitancy-for-COVID-19-County-and-local-es/q9mh-h2tw

## COVID-associated Hospitalization from CDC ----
# https://gis.cdc.gov/grasp/COVIDNet/COVID19_3.html
