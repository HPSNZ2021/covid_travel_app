## COVID-19 Travel Policy Tracking
## Ben Day
## Created: 14/7/2020
## Modified: 14/7/2020
##
## Source: https://covidtracker.bsg.ox.ac.uk/


library(tidyverse)
library(jsonlite)


# Read in stringency data from API -------------------------------------------------

start <- "2020-05-01"
end <- as.character(Sys.Date())


json_file <- paste0("https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/date-range/", start, "/", end)
df <- fromJSON(txt = json_file)


# Read in timeseries csv --------------------------------------------------

df <- read.csv()
