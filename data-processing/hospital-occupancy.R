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

# Convert collection_week to Date class
patientImpact.hospitalCapacity$collection_week <- as.Date(patientImpact.hospitalCapacity$collection_week)

# Create week_number column
week_number <- strftime(patientImpact.hospitalCapacity$collection_week, format = "%V")
patientImpact.hospitalCapacity <- add_column(patientImpact.hospitalCapacity, 
                                             week_number, .after = 1)

# Delete excessive variables
strings.to.check <- c("organized.capacity", "hospital_pk", "state", 
                      "ccn", "hospital_name", "address", "city", "zip", 
                      "hospital_subtype", "pediatric", "influenza", "suspected", 
                      "admission", "vaccinated", "ED", "is_metro_micro", 
                      "hhs_ids", "is_corrected", 
                      "all_adult_hospital_beds_7_day_avg")

for (string in strings.to.check) {
  matching.vars <- grep(string, colnames(patientImpact.hospitalCapacity))
  if (length(matching.vars) > 0) {
    patientImpact.hospitalCapacity <-
      patientImpact.hospitalCapacity[, -matching.vars]
  }
}

# Check how many N/A terms in a column
column.to.check <- "all_adult_hospital_beds_7_day_avg"
na.count <- sum(is.na(patientImpact.hospitalCapacity[[column.to.check]]))
cat(paste("The number of N/A values in column", column.to.check, 
          "is:", na.count)) # too many cases missing for this column