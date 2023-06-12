# Load libraries
library(tidyverse)
library(readxl)
library(janitor)

# Read in raw files
ship_data <- read_excel("raw_data/seabirds.xls", sheet = "Ship data by record ID")
bird_data <- read_excel("raw_data/seabirds.xls", sheet = "Bird data by record ID")

# Join bird and ship data
bird_counts <-  left_join(bird_data, ship_data, by = "RECORD ID") %>% 
  # all 49,019 bird observations x many variables
  # select required variables only
  select(`RECORD ID`, LAT, `Species common name (taxon [AGE / SEX / PLUMAGE PHASE])`, `Species  scientific name (taxon [AGE /SEX /  PLUMAGE PHASE])`, `Species abbreviation`, COUNT) %>% 
  # rename columns, as per tidy data style
  clean_names() %>% 
  rename(
    common_name = species_common_name_taxon_age_sex_plumage_phase,
    sci_name = species_scientific_name_taxon_age_sex_plumage_phase
  )

# View subsetted data
glimpse(bird_counts)

