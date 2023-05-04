# Package prep ----
require(tidyr)
require(dplyr)
require(tibble)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)
require(leaps)

# Data prep ----
hospital <- read_csv("https://www.dropbox.com/s/worwm4rnh8mu7tj/patient-impact-hospital-capacity-cleaned.csv?dl=1") # Processed hospital capacity
places <- read_csv("https://www.dropbox.com/s/wqz4xrir84g60qy/places-project-chronic-diseases-cleaned.csv?dl=1") # Processed PLACES project data
covid <- read_csv("https://www.dropbox.com/s/ttj2bfdmspfsiw7/covid-cases-deaths-cleaned.csv?dl=1") # COVID-19 cases and deaths
vaccination <- read_csv("https://www.dropbox.com/s/bj9xofn2ctmtjtj/us_vaccination-cleaned.csv?dl=1") # Vaccination data
demographic <- read_csv("https://www.dropbox.com/s/b5o11qew0d899p3/demographic-final.csv?dl=1") # Demographic data
economics <- read_csv("https://www.dropbox.com/s/hvtlxdspndnxizs/economic-characteristics-cleaned.csv?dl=1") # Economics data

# New calculated variables for hospital occupancy data ----

attach(hospital) # calculate percentages for COVID patients
perc_adult_covid_hospitalized <-
  total_adult_patients_hospitalized_confirmed_covid_7_day_avg/
  all_adult_hospital_inpatient_bed_occupied_7_day_avg # percent of COVID patients among all hospitalized patients
perc_adult_covid_icu <-
  staffed_icu_adult_patients_confirmed_covid_7_day_avg/
  staffed_adult_icu_bed_occupancy_7_day_avg # percent of COVID patients among all ICU patients

# Adult inpatient beds
all_adult_inpatient_beds_perc_occupied <- 
  inpatient_beds_used_7_day_sum/
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

new_columns <- data.frame(perc_adult_covid_hospitalized, 
                          perc_adult_covid_icu, 
                          all_adult_inpatient_beds_perc_occupied, 
                          all_adult_inpatient_beds_perc_coverage, 
                          covid_all_adult_inpatient_beds_perc_occupied, 
                          covid_all_adult_inpatient_beds_perc_coverage,
                          all_adult_icu_beds_perc_coverage, 
                          covid_all_adult_icu_beds_perc_occupied, 
                          covid_all_adult_icu_beds_perc_coverage)

# Variable processing ----

## Column name change ----
# COVID data
colnames(covid)[colnames(covid) == "fips"] <- "fips_code"

# PLACES data
colnames(places)[colnames(places) == "fips"] <- "fips_code"
colnames(places)[colnames(places) == "week"] <- "week_number"
colnames(places)[colnames(places) == "year"] <- "year_number"
View(places)

# Vaccination data
colnames(vaccination)[colnames(vaccination) == "FIPS"] <- "fips_code"
colnames(vaccination)

# Demographic data
colnames(demographic)[colnames(demographic) == "fips"] <- "fips_code"
colnames(demographic)[colnames(demographic) == "week"] <- "week_number"
colnames(demographic)[colnames(demographic) == "year"] <- "year_number"
demographic$...1 <- NULL

# Economics data
colnames(economics)[colnames(economics) == "Fips"] <- "fips_code"
colnames(economics)[colnames(economics) == "Week"] <- "week_number"
colnames(economics)[colnames(economics) == "Year"] <- "year_number"
economics$Geography <- NULL
economics$`Geographic Area Name` <- NULL
 
# Hospital data
colnames(hospital)
hospital <- hospital[, -c(4:38)]
combined_hospital <- cbind(hospital, new_columns)
colnames(combined_hospital)

## Merging ----
# by week_number, year_number, and fips_code
df_list <- list(combined_hospital, covid, vaccination, 
                demographic, places, economics)
combined <- Reduce(function(x, y) 
  merge(x, y, by = c("week_number", "year_number", "fips_code")), df_list)
colnames(combined)

# Change every NA term to generic name NA
combined[is.na(combined) | combined == "Inf"] = NA
new_combined <- na.omit(combined, cols = "CFR")

# Export ----
<<<<<<< HEAD
write.csv(combined, 
          file = "/Users/cameronlian/Library/CloudStorage/Dropbox/Health Crisis Predictive Model Project/final-integrated-data.csv", 
=======
write.csv(new_combined, 
          file = "~/OneDrive - Grinnell College/2022-23/Spring/STA310/project/finalprojectsta310/final-integrated-data.csv", 
>>>>>>> 6fd7d45868ec8c33e7f426f070c524e5f362d4d7
          row.names = FALSE)

# Models ----
## Original linear regression model ----
full_model <- lm(`CFR` ~ ., data = combined)
stepwise_model <- step(full_model)
summary(step_model)

# Calculate percent missing variables ----
# missing_data <- data.frame(variable = colnames(new.combined), 
#                            missing_percentage = 
#                              colMeans(is.na(new.combined)) * 100)
# write.csv(missing_data, file = "/Users/cameronlian/Desktop/missing_data.csv", 
#           row.names = FALSE)