# Package prep
require(tidyr)
require(dplyr)
require(tibble)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)

# Dataset was processed in a separate document; new variables will be created
# and calculated
dataset <- read_csv("https://www.dropbox.com/s/r3e5u7cz30ibe33/patient-impact-hospital-capacity-merged.csv?dl=1") # Processed hospital capacity
covid <- read_csv("https://www.dropbox.com/s/y8wrfcq1ntl30pf/covid-cases-deaths.csv?dl=1") # COVID-19 cases and deaths
View(dataset)
View(covid)

# Change the column name in covid
colnames(covid)[colnames(covid) == "fips"] <- "fips_code"

# Merge the two datasets by week_number, year_number, and fips_code
# Ignore any columns that did not match by mentioned variables
combined <- merge(dataset, covid, 
                  by = c("week_number", "year_number", "fips_code"), 
                  all.x = TRUE)

attach(combined) # calculate percentages for COVID patients
perc_adult_covid_hospitalized <-
  total_adult_patients_hospitalized_confirmed_covid_7_day_avg/
  all_adult_hospital_inpatient_bed_occupied_7_day_avg # percent of COVID patients among all hospitalized patients
perc_adult_covid_icu <-
  staffed_icu_adult_patients_confirmed_covid_7_day_avg/
  staffed_adult_icu_bed_occupancy_7_day_avg # percent of COVID patients among all ICU patients

# Adult inpatient beds
all_adult_inpatient_beds_perc_occupied <- 
  inpatient_beds_used_7_day_avg/
  inpatient_beds_7_day_avg # percent of occupancy for all inpatient beds
all_adult_inpatient_beds_perc_coverage <-
  inpatient_beds_7_day_coverage/
  inpatient_beds_7_day_avg # percent of coverage for all inpatient beds
covid_all_adult_inpatient_beds_perc_occupied <- 
  total_adult_patients_hospitalized_confirmed_covid_7_day_avg/
  inpatient_beds_7_day_avg # percent of occupancy for COVID hospitalized
covid_all_adult_inpatient_beds_perc_coverage <-
  total_adult_patients_hospitalized_confirmed_covid_7_day_coverage/
  inpatient_beds_7_day_avg # percent of staff coverage for COVID hospitalized

# Adult ICU beds
all_adult_icu_beds_perc_coverage <-
  staffed_adult_icu_bed_occupancy_7_day_coverage/
  total_staffed_adult_icu_beds_7_day_avg # percent of coverage for all ICU beds
covid_all_adult_icu_beds_perc_occupied <-
  staffed_icu_adult_patients_confirmed_covid_7_day_avg/
  total_staffed_adult_icu_beds_7_day_avg # percent of occupancy among COVID ICU
covid_all_adult_icu_beds_perc_coverage <-
  staffed_icu_adult_patients_confirmed_covid_7_day_coverage/
  total_staffed_adult_icu_beds_7_day_avg # percent of staff coverage among COVID ICU

detach()

ls(combined)
combined.processed <- combined
combined.processed[, 4:42] <- NULL

new.columns <- data.frame(perc_adult_covid_hospitalized, 
                          perc_adult_covid_icu, 
                          all_adult_inpatient_beds_perc_occupied, 
                          all_adult_inpatient_beds_perc_coverage, 
                          covid_all_adult_inpatient_beds_perc_occupied, 
                          covid_all_adult_inpatient_beds_perc_coverage, 
                          all_adult_icu_beds_perc_occupied, 
                          all_adult_icu_beds_perc_coverage, 
                          covid_all_adult_icu_beds_perc_occupied, 
                          covid_all_adult_icu_beds_perc_coverage)
new.combined <- cbind(combined.processed, new.columns)
colnames(new.combined)

# Calculate the percentage of missing data in new.combined
missing_data <- data.frame(variable = colnames(new.combined), 
                           missing_percentage = 
                             colMeans(is.na(new.combined)) * 100)
write.csv(missing_data, file = "/Users/cameronlian/Desktop/missing_data.csv", row.names = FALSE)