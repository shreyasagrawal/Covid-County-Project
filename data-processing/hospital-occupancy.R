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
missing_data <- data.frame(variable = colnames(patientImpact.hospitalCapacity), 
                           missing_percentage = 
                             colMeans(is.na(patientImpact.hospitalCapacity)) * 100)
write.csv(missing_data, file = "/Users/cameronlian/Desktop/missing_data.csv", row.names = FALSE)

# Convert collection_week to Date class
patientImpact.hospitalCapacity$collection_week <- as.Date(patientImpact.hospitalCapacity$collection_week)

# Create year_number column
year_number <- strftime(patientImpact.hospitalCapacity$collection_week, 
                        format = "%Y")
patientImpact.hospitalCapacity <- add_column(patientImpact.hospitalCapacity, 
                                             year_number, .after = 1)

# Create week_number column
week_number <- strftime(patientImpact.hospitalCapacity$collection_week, 
                        format = "%V")
patientImpact.hospitalCapacity <- add_column(patientImpact.hospitalCapacity, 
                                             week_number, .after = 2)

# Delete excessive variables
strings.to.check <- c("hospital_name", "hospital_subtype", "organized.capacity", "hospital_pk", "state", 
                      "ccn", "address", "city", "zip", 
                      "pediatric", "influenza", "suspected", 
                      "admission", "vaccinated", "ED", "is_metro_micro", 
                      "hhs_ids", "is_corrected", 
                      "total_beds_7_day_avg")

# total_beds_7_day_avg was deleted because it included both inpatient and 
# outpatient beds, of which the outpatient beds were also included in the total 
# count of ICU beds for each hospital

for (string in strings.to.check) {
  matching.vars <- grep(string, colnames(patientImpact.hospitalCapacity))
  if (length(matching.vars) > 0) {
    patientImpact.hospitalCapacity <-
      patientImpact.hospitalCapacity[, -matching.vars]
  }
}

# Delete all rows others than 2020 and 2021
patientImpact.hospitalCapacity <- patientImpact.hospitalCapacity %>% 
  filter(year_number == 2020 | year_number == 2021)

# Integrate rows with the same week_number, year_number, and fips_code
# Because all variables were counts, making integration by additions reasonable
patientImpact.hospitalCapacity <- patientImpact.hospitalCapacity %>% 
  group_by(year_number, week_number, fips_code) %>% 
  # summarise(across(1:4, first), 
  #           across(5:39, ~ (if (n() == 1) first 
  #                           else sum(., na.rm = TRUE)))) %>% 
  summarise(across(5:39, sum, 
                   na.rm = TRUE))

# Change -999999.00 to N/A
# -999999.00 represents the suppression to the file for sums and averages less 
# than four, for which assuming it to be 0 will not be reasonable because we 
# may not know the actual value -999999.00 represents
patientImpact.hospitalCapacity[patientImpact.hospitalCapacity ==
                                 -999999.0] <- NA
patientImpact.hospitalCapacity[patientImpact.hospitalCapacity ==
                                 -999999] <- NA

write.csv(patientImpact.hospitalCapacity, 
          file = "/Users/cameronlian/Desktop/patient-impact-hospital-capacity-merged.csv", 
          row.names = FALSE)

# Check how many N/A terms in a column
# column.to.check <- "all_adult_hospital_beds_7_day_avg"
# na.count <- sum(is.na(patientImpact.hospitalCapacity[[column.to.check]]))
# cat(paste("The number of N/A values in column", column.to.check, 
#           "is:", na.count)) # too many cases missing for this column