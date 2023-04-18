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
dataset <- read_csv("https://www.dropbox.com/s/r3e5u7cz30ibe33/patient-impact-hospital-capacity-merged.csv?dl=1")
View(dataset)
