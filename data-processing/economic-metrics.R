# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)q

# Economics characteristics dataset from Census data ----

econ.2019 <- read.csv("https://www.dropbox.com/s/onf0wf2l0j6tl84/economic-characteristics-2019.csv?dl=1")
econ.2020 <- read.csv("https://www.dropbox.com/s/te81iz8nmg1q9ks/economic-characteristics-2020.csv?dl=1")
econ.2021 <- read.csv("https://www.dropbox.com/s/q0iod9xnpjjdpcl/economic-characteristics-2021.csv?dl=1")
### Combining all datasets above into a whole data set ----
econ.all <- rbind(econ.2019, econ.202, econ.2021)
