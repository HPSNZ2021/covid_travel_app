# HPSNZ Travel App: International Travel Restrictions

This repository houses the shiny app code that uses publicly available data (Oxford COVID-19 Government Response Tracker) data to answer questions about country travel restrictions. The purpose of this app if to provide a ‘shortcut to information’ that can assist with campaign planning for HPSNZ and sport staff.

As a self-service tool, this web app enables HPSNZ and NSO staff to quickly find information that may assist in their planning for international training and competitions.

## Data sources

The open-source dataset this app utilises is the **COVID TRACKER: Oxford COVID-19 Government Response Tracker** collaborative project by Oxford University (https://covidtracker.bsg.ox.ac.uk/). It aims to monitor and aggregate Government response measures across economic, travel, and societal areas using a novel **stringency index**. This application focuses on a single measure contained within this index - international travel restrictions - which is (ideally) updated daily for each country.

In the first iteration of this app a flat file Excel workbook (downloaded from the website above) serves as the sole data source for this analysis tool.

## App interface

This app has been built using R and RStudio by utilising the `RShiny` package for web app development. This open-source platform bridges the gap between web development (programming in HTML, javascript, etc) and basic level statistical software programming. `RShiny` contains many 'helper' functions that make it easy to integrate web page elements into a functional user interface.

**Inputs**
1. COUNTRY to search travel status (drop-down list)
2. TRAVEL STATUS to search relevant countries (single select)
  1. Screening arrivals
  2. Quarantine some or all arrivals
  3. Ban arrivals from some regions
  4. Border closed to foreign travellers

**Outputs**
  + Time-series chart of Country (1) travel restriction status. Shows history of restriction levels since early 2020 for historical context.
  + List of countries at selected Travel Status (2) alongside date of last update at this status. Shows the 'bucket' of countries in the given status level for regional context.


## Access and security

Users must 'opt-in' to access the web application. Therefore there is some minimal administration of users that is required. This is made very simple through the [**shinyapps.io** platform], which through a paid subscription allows hosting of the app on a secure *shiny server* instance (https://rstudio.com/products/shiny/shiny-server/).

New users provide an email address, which will then be invited to sign up for a *shinyapps* account. This account is then used to authenticate the user and grant access through to the web app (also sent in invitation email).

The HPSNZ email address **intelligence@hpsnz.org.nz** is linked to the *shinyapps* subscription account.

[**shinyapps.io** platform]: https://www.shinyapps.io/

## Future improvements

Further iterations of this application could expand functionality across multiple areas. Some of these are listed below, where specific suggestions are also noted.

  - **Suggeston** - Country travel status could be augmented and improved by providing shortcuts to the 'stopover' airports/cities. This would answer the question of '*what is the easiest flight route to arrive at the destination country of choice?*'
  - Provide links to each country travel restriction website information. This would provide an additional shortcut once the existing functionality has helped the user identify the context for their destination country.
