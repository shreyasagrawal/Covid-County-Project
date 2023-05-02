# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)
require(stringr)
# Economics characteristics dataset from Census data ----

#econ.2019 <- read.csv("https://www.dropbox.com/s/onf0wf2l0j6tl84/economic-characteristics-2019.csv?dl=1")
econ.2020 <- read.csv("https://www.dropbox.com/s/te81iz8nmg1q9ks/economic-characteristics-2020.csv?dl=1")
econ.2021 <- read.csv("https://www.dropbox.com/s/q0iod9xnpjjdpcl/economic-characteristics-2021.csv?dl=1")

### Add week
econ.2020 <-  econ.2020 %>% slice(rep(1:n(),52)) %>% mutate(`Year` = 2020, `Week` = rep(1:52,each = 3222))
econ.2021 <-  econ.2021 %>% slice(rep(1:n(),52)) %>% mutate(`Year` = 2021, Week = rep(1:52,each = 3222))

### Combining all datasets above into a whole data set ----
econ.all <- rbind(econ.2020, econ.2021)


### Choosing variables 
econ.all <- econ.all %>% select('GEO_ID','NAME','DP03_0001E','DP03_0005E','DP03_0021E','DP03_0119PE','DP03_0095PE','DP03_0051PE','DP03_0042PE','Year','Week') 

### Rename the columns, remove the first colummn
colnames(econ.all) <- econ.all[1,]
econ.all <- econ.all[-1,]
names(econ.all)[names(econ.all) == 'Estimate!!EMPLOYMENT STATUS!!Population 16 years and over!!In labor force!!Civilian labor force!!Unemployed'] <- 'Estimate Unemployment'
names(econ.all)[names(econ.all) == 'Percent!!PERCENTAGE OF FAMILIES AND PEOPLE WHOSE INCOME IN THE PAST 12 MONTHS IS BELOW THE POVERTY LEVEL!!All families'] <- 'Household Income Below Poverty Level Percentage'
names(econ.all)[names(econ.all) == 'Estimate!!COMMUTING TO WORK!!Workers 16 years and over!!Public transportation (excluding taxicab)'] <- 'Public Transport Commutation'
names(econ.all)[names(econ.all) == 'Percent!!HEALTH INSURANCE COVERAGE!!Civilian noninstitutionalized population'] <- 'Health Insurance Coverage Percentage'
names(econ.all)[names(econ.all) == 'Percent!!INCOME AND BENEFITS (IN 2020 INFLATION-ADJUSTED DOLLARS)!!Total households'] <- 'Household Income and Benefits'
names(econ.all)[names(econ.all) == 'Percent!!INDUSTRY!!Civilian employed population 16 years and over!!Educational services, and health care and social assistance'] <- 'Edu Health Social Industry Percentage'
names(econ.all)[names(econ.all) == 'Estimate!!EMPLOYMENT STATUS!!Population 16 years and over'] <- 'Population 16 and Over'

econ.all$`Population 16 and Over` <- as.numeric(econ.all$`Population 16 and Over`)
econ.all$`Estimate Unemployment` <- as.numeric(econ.all$`Estimate Unemployment`)
econ.all$`Public Transport Commutation` <- as.numeric(econ.all$`Public Transport Commutation`)
econ.all$`Household Income Below Poverty Level Percentage` <- as.numeric(econ.all$`Household Income Below Poverty Level Percentage`)
econ.all$`Health Insurance Coverage Percentage` <- as.numeric(econ.all$`Health Insurance Coverage Percentage`)
econ.all$`Edu Health Social Industry Percentage` <- as.numeric(econ.all$`Edu Health Social Industry Percentage`)
econ.all <- econ.all %>% mutate(`Unemployment Rate` = `Estimate Unemployment`/`Population 16 and Over`,
                                `Health Insurance Coverage Percentage` = `Health Insurance Coverage Percentage`/`Population 16 and Over`,
                                `Public Transport Commutation` = `Public Transport Commutation`/`Population 16 and Over`)
### Check null
#length(which(is.na(econ.all)))

### Add fips code 
econ.all$Fips <- str_sub(econ.all$Geography,-5,-1)
###
econ.all$Year = econ.all$`2020`
econ.all$Week = econ.all$`1`
econ.all <- econ.all %>% select(!`2020`&!`1`)

