# install.packages("tigris")
# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)
library(tigris)
# Economics characteristics dataset from Census data ----

#econ.2019 <- read.csv("https://www.dropbox.com/s/onf0wf2l0j6tl84/economic-characteristics-2019.csv?dl=1")
econ.2020 <- read.csv("https://www.dropbox.com/s/te81iz8nmg1q9ks/economic-characteristics-2020.csv?dl=1")
econ.2021 <- read.csv("https://www.dropbox.com/s/q0iod9xnpjjdpcl/economic-characteristics-2021.csv?dl=1")


### Combining all datasets above into a whole data set ----
econ.all <- rbind(econ.2020, econ.2021)


### Choosing variables 
econ.all <- econ.all %>% select('GEO_ID','NAME','DP03_0005E','DP03_0021E','DP03_0119PE','DP03_0095PE','DP03_0051PE','DP03_0042PE') 

### Rename the columns, remove the first colummn
colnames(econ.all) <- econ.all[1,]
econ.all <- econ.all[-1,]
names(econ.all)[names(econ.all) == 'Estimate!!EMPLOYMENT STATUS!!Population 16 years and over!!In labor force!!Civilian labor force!!Unemployed'] <- 'Estimate Unemployment'
names(econ.all)[names(econ.all) == 'Percent!!PERCENTAGE OF FAMILIES AND PEOPLE WHOSE INCOME IN THE PAST 12 MONTHS IS BELOW THE POVERTY LEVEL!!All families'] <- 'Household Income Below Poverty Level Percentage'
names(econ.all)[names(econ.all) == 'Estimate!!COMMUTING TO WORK!!Workers 16 years and over!!Public transportation (excluding taxicab)'] <- 'Public Transport Commutation'
names(econ.all)[names(econ.all) == 'Percent!!HEALTH INSURANCE COVERAGE!!Civilian noninstitutionalized population'] <- 'Health Insurance Coverage Percentage'
names(econ.all)[names(econ.all) == 'Percent!!INCOME AND BENEFITS (IN 2020 INFLATION-ADJUSTED DOLLARS)!!Total households'] <- 'Household Income and Benefits'
names(econ.all)[names(econ.all) == 'Percent!!INDUSTRY!!Civilian employed population 16 years and over!!Educational services, and health care and social assistance'] <- 'Edu Health Social Industry Percentage'

### Check null
length(which(is.na(econ.all)))

### Add fips code 
data(fips_codes)
as.character(fips_codes$state_code)
as.character(fips_codes$county_code)
fips_codes$fips <- paste(fips_codes$state_code, fips_codes$county_code, sep = "", collapse = NULL)
as.numeric(fips_codes$fips)

###
econ.all <- econ.all %>% separate(`Geographic Area Name`, sep=",", into = c("County", "State")) 
full_join(econ.all, fips_codes, by=c('State'='state_name', 'County'='county'))

