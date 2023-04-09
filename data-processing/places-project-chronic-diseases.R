# Package prep
require(tidyr)
require(dplyr)
require(readr)
require(mosaic)
require(ggplot2)
require(reshape2)

# Data prep
places.2020 <- read_csv("https://www.dropbox.com/s/6p43l8phzm1qj85/County%20Data%20%28GIS%20Friendly%20Format%29%2C%202020%20release.csv?dl=1")
places.2021 <- read_csv("https://www.dropbox.com/s/o2t8n606trxska6/County%20Data%20%28GIS%20Friendly%20Format%29%2C%202021%20release.csv?dl=1")
places.2022 <- read_csv("https://www.dropbox.com/s/27en8ytece1d3vd/County%20Data%20%28GIS%20Friendly%20Format%29%2C%202022%20release.csv?dl=1")