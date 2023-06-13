# Load libraries
library(tidyverse)
library(readxl)
library(janitor)
library(assertr)

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

bird_counts_clean <- bird_counts # make "clean" version to work with next

# clean str data within bird info columns to remove age, plummage, 
# and other unnecessary strings appended after the bird names
bird_counts_clean <- bird_counts_clean %>% 
  mutate(common_name = str_replace_all(bird_counts_clean$common_name, c(
    "\\ AD*" = "", 
    "\\ JUV*" = "", 
    "\\ IMM*" = "",
    "\\ SUBAD*" = "", 
    "\\ sensu\\ lato*" = "",
    "\\ PL[0-9]*" = "",
    "\\ LGHT*" = "",
    "\\ DRK*" = ""))) %>% 
  mutate(sci_name = str_replace_all(bird_counts_clean$sci_name, c(
    "\\ AD*" = "", 
    "\\ JUV*" = "", 
    "\\ IMM*" = "",
    "\\ SUBAD*" = "", 
    "\\ sensu\\ lato*" = "",
    "\\ PL[0-9]*" = "",
    "\\ LGHT*" = "",
    "\\ DRK*" = ""))) %>% 
  mutate(species_abbreviation = str_replace_all(bird_counts_clean$species_abbreviation, c(
    "\\ AD*" = "", 
    "\\ JUV*" = "", 
    "\\ IMM*" = "",
    "\\ SUBAD*" = "", 
    "\\ sensu\\ lato*" = "",
    "\\ PL[0-9]*" = "",
    "\\ LGHT*" = "",
    "\\ DRK*" = "")))
# Note: not yet dealing with M at end (for medium plummage) because too non-specific
# or a random F in one that I saw somewhen through cleaning experimentation

# write subsetted data to new file, note: not yet cleaned data within cols.
write_csv(bird_counts, "clean_data/bird_counts_raw.csv")

# write subsetted & cleaned data to new file
write_csv(bird_counts_clean, "clean_data/bird_counts_cleaned.csv")