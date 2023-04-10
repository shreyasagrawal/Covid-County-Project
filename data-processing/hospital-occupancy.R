# Package prep
require(tidyr)
require(dplyr)
require(tibble)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)

# COVID-19 Reported Patient Impact and Hospital Capacity by Facility: https://healthdata.gov/Hospital/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/anag-cw7u
# COVID-19 Reported Patient Impact and Hospital Capacity by Facility (data source): https://healthdata.gov/stories/s/nhgk-5gpv
patientImpact.hospitalCapacity <- read_csv("https://www.dropbox.com/s/fgb0ga3o84bfajp/covid-19_reported_patient_impact_and_hospital_capacity_by_facility.csv?dl=1")
View(patientImpact.hospitalCapacity)

patientImpact.hospitalCapacity$collection_week <- as.Date(patientImpact.hospitalCapacity$collection_week)
class(patientImpact.hospitalCapacity$collection_week)

# Create week_number column
week_number <- strftime(patientImpact.hospitalCapacity$collection_week, format = "%V")
patientImpact.hospitalCapacity <- add_column(patientImpact.hospitalCapacity, 
                                             week_number, .after = 1)
View(patientImpact.hospitalCapacity)

# Delete excessive variables
patientImpact.hospitalCapacity <- patientImpact.hospitalCapacity %>% 
  select(-hospital_pk, -state, -ccn, -hospital_name, -address, -city, -zip, -hospital_subtype, -is_metro_micro)
View(patientImpact.hospitalCapacity)

patientImpact.hospitalCapacity <- as.data.frame(patientImpact.hospitalCapacity)
patientImpact.county <- aggregate(patientImpact.hospitalCapacity[, 4:ncol(patientImpact.hospitalCapacity)] ~ 
                                          fips_code + week_number, 
                                        na.omit(patientImpact.hospitalCapacity), mean)