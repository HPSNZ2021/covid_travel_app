## Update data source
# Author: Ben Day
# Date created: 18/05/2020
# Date modified: 18/09/2020
# -------------------------------

library(tidyverse)
library(lubridate)
library(readxl)
library(httr)


# Download data as temporary file

url <- 'https://github.com/OxCGRT/covid-policy-tracker/raw/master/data/timeseries/OxCGRT_timeseries_all.xlsx'
httr::GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))


# Read raw data -----------------------------------------------------------

#setwd(paste0(path, '/data'))
#a <- list.files(pattern = '*.xlsx')
#df <- read_xlsx(path = paste0(a[2]), sheet = 'c8_internationaltravel')
#df <- read_xlsx(path = paste0(a[length(a)]), sheet = 'c8_internationaltravel')

# Read temporary file
df <- read_excel(tf, sheet = 'c8_internationaltravel')

df_name <- "covid_country_data"


# Pre processing ----------------------------------------------------------

df <- df %>% pivot_longer(
  cols = colnames(df[, !names(df) %in% c('CountryName', 'CountryCode')]),
  names_to = "date",
  values_to = "code",
  values_drop_na = TRUE
)


# Save RDS ----------------------------------------------------------------

#setwd('..')
saveRDS(df, file = paste0(df_name, ".rds"))

rm(df, url, df_name)
