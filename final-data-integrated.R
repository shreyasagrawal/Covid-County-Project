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
covid$week_number <- gsub("^0([1-9])$", "\\1", covid$week_number)
covid$fips_code <- ifelse(nchar(covid$fips_code) == 4, 
                          paste0("0", covid$fips_code), 
                          covid$fips_code)

# PLACES data
colnames(places)[colnames(places) == "fips"] <- "fips_code"
colnames(places)[colnames(places) == "week"] <- "week_number"
colnames(places)[colnames(places) == "year"] <- "year_number"
places$week_number <- gsub("^0([1-9])$", "\\1", places$week_number)
places$fips_code <- ifelse(nchar(places$fips_code) == 4, 
                          paste0("0", places$fips_code), 
                          places$fips_code)
View(places)

# Vaccination data
colnames(vaccination)[colnames(vaccination) == "FIPS"] <- "fips_code"
colnames(vaccination)
# vaccination$week_number <- gsub("^01$", "1", vaccination$week_number)
# vaccination$week_number <- gsub("^02$", "2", vaccination$week_number)
# vaccination$week_number <- gsub("^03$", "3", vaccination$week_number)
# vaccination$week_number <- gsub("^04$", "4", vaccination$week_number)
# vaccination$week_number <- gsub("^05$", "5", vaccination$week_number)
# vaccination$week_number <- gsub("^06$", "6", vaccination$week_number)
# vaccination$week_number <- gsub("^07$", "7", vaccination$week_number)
# vaccination$week_number <- gsub("^08$", "8", vaccination$week_number)
# vaccination$week_number <- gsub("^09$", "9", vaccination$week_number)
vaccination$week_number <- gsub("^0([1-9])$", "\\1", vaccination$week_number)
vaccination$fips_code <- ifelse(nchar(vaccination$fips_code) == 4, 
                           paste0("0", vaccination$fips_code), 
                           vaccination$fips_code)
View(vaccination)

# Demographic data
colnames(demographic)[colnames(demographic) == "fips"] <- "fips_code"
colnames(demographic)[colnames(demographic) == "week"] <- "week_number"
colnames(demographic)[colnames(demographic) == "year"] <- "year_number"
demographic$week_number <- gsub("^0([1-9])$", "\\1", demographic$week_number)
demographic$fips_code <- ifelse(nchar(demographic$fips_code) == 4, 
                                paste0("0", demographic$fips_code), 
                                demographic$fips_code)
demographic$...1 <- NULL

# Economics data
colnames(economics)[colnames(economics) == "Fips"] <- "fips_code"
colnames(economics)[colnames(economics) == "Week"] <- "week_number"
colnames(economics)[colnames(economics) == "Year"] <- "year_number"
economics$Geography <- NULL
economics$`Geographic Area Name` <- NULL
economics$week_number <- gsub("^0([1-9])$", "\\1", economics$week_number)
economics$fips_code <- ifelse(nchar(economics$fips_code) == 4, 
                              paste0("0", economics$fips_code), 
                              economics$fips_code)
 
# Hospital data
colnames(hospital)
hospital <- hospital[, -c(4:38)]
combined_hospital <- cbind(hospital, new_columns)
colnames(combined_hospital)
combined_hospital$week_number <- gsub("^0([1-9])$", "\\1", 
                                      combined_hospital$week_number)
combined_hospital$fips_code <- ifelse(nchar(combined_hospital$fips_code) == 4, 
                              paste0("0", combined_hospital$fips_code), 
                              combined_hospital$fips_code)

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

# Remove case/death numbers and differences from new_combined
new_combined$cases <- NULL
new_combined$deaths <- NULL
new_combined$diff.cases <- NULL
new_combined$diff.deaths <- NULL

# Move CFR column to the first 
new_combined <- new_combined[, c("CFR", 
                                 setdiff(names(new_combined), 
                                         "CFR"))]
new_combined_2021 <- subset(new_combined, year_number == 2021)
View(new_combined_2021)

# Export ----
write.csv(new_combined_2021, 
          file = "/Users/cameronlian/Desktop/Covid-County-Project/final-integrated-data.csv", 
          row.names = FALSE)
write.csv(new_combined_2021, 
          file = "/Users/cameronlian/Library/CloudStorage/Dropbox/Health Crisis Predictive Model Project/final-integrated-data.csv", 
          row.names = FALSE) # dropbox

# Models ----
## Splitting the original data frame into halves
half <- ncol(new_combined_2021) %/% 2 + 4
new_combined_1 <- new_combined_2021[, c(1:4, 5:half)]
new_combined_2 <- new_combined_2021[, c(1:4, (half+1):ncol(new_combined_2021))]
View(new_combined_1)
View(new_combined_2)

## Splitting into four smaller data frames
# Determine the number of splits and the size of each split
n_splits <- 4
split_size <- (ncol(new_combined_2021) - 4) / n_splits

# Initialize a list to store the resulting dataframes
df_list <- list()

# Use a loop to split the dataframe into smaller dataframes
for (i in seq_len(n_splits)) {
  start_col <- (i - 1) * split_size + 5
  end_col <- start_col + split_size - 1
  df_list[[i]] <- cbind(new_combined_2021[,1:4], 
                        new_combined_2021[,start_col:end_col])
}

quarter_1 <- df_list[[1]]
quarter_2 <- df_list[[2]]
quarter_3 <- df_list[[3]]
quarter_4 <- df_list[[4]]

## Linear regression model ----
fit_1 <- lm(CFR ~ ., data = quarter_1)
fit_2 <- lm(CFR ~ ., data = quarter_2)
fit_3 <- lm(CFR ~ ., data = quarter_3)
fit_4 <- lm(CFR ~ ., data = quarter_4)

## Stepwise regression model ----
step_1 <- step(fit_1)
step_2 <- step(fit_2)
step_3 <- step(fit_3)
step_4 <- step(fit_4)
summary(step_1)
summary(step_2)

# Calculate percent missing variables ----
# missing_data <- data.frame(variable = colnames(new.combined), 
#                            missing_percentage = 
#                              colMeans(is.na(new.combined)) * 100)
# write.csv(missing_data, file = "/Users/cameronlian/Desktop/missing_data.csv", 
#           row.names = FALSE)