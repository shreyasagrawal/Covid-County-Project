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
View(combined)