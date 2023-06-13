# Script to clean raw data (excel spreadsheets) from 2015, 2016, 2017

# required libraries
library(tidyverse)
library(readxl)
library(janitor)

# load in raw data files
x2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx", sheet = "Form Responses 1")
x2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx", sheet = "Form Responses 1")
x2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx", sheet = "responses (2) (1).csv")

# 2015 data: subset and make long format

## step 1: subset to remove unwanted columns
x2015_subset <- x2015 %>% 
  select(1:17,19:22,24,25,29:32,35:37,39:40,42:44,
         46:55,57:81,83:89,91,92,96,114,115) #,98,99) 
    # include 98,99 if retaining additional ratings information

## step 2: clean up included variables to produce required common df structure: 
# [1]id [2]year [3]age [4]gender [5]country 
# [6]goes_trick_or_treating [7]candy_item [8]rating
x2015_subset_converted <- x2015_subset %>% 
  # make an id column to retain unique identifier for each person
  mutate(id = c(1:5630), .before = "Timestamp") %>% 
  # rename variables
  rename(age = "How old are you?",
         goes_trick_or_treating = "Are you going actually going trick or treating yourself?",
         year = "Timestamp") %>% #,
         # additional_joy = "Please list any items not included above that give you JOY.",
         # additional_despair = "Please list any items not included above that give you DESPAIR.") %>%
      # include additional_y renaming if retaining additional ratings information
  # recode some specific age values before converting to numeric (see "Coerced age data" below)
  mutate(age = case_when(
    id == 378 ~ "45",
    id == 792 ~ "37",
    id == 1210 ~ "43",
    id == 1571 ~ "46",
    id == 1629 ~ "40",
    id == 2207 ~ "37",
    id == 2934 ~ "50",
    id == 3384 ~ "27",
    id == 3626 ~ "50",
    id == 4798 ~ "42",
    id == 5624 ~ "50",
    .default = age)) %>% 
  # change format of age and year data
  mutate(age = as.integer(age), # Note: this introduces NAs by coercion
         year = as.numeric(format(year, "%Y"))) %>% 
  # make empty columns for gender and country (missing in this year's dataset)
  mutate(gender = rep(NA_character_, nrow(x2015_subset)), .after = age) %>% 
  mutate(country = rep(NA_character_, nrow(x2015_subset)), .after = gender) 
# expect dim: 5630 observations x 85 variables
# cols 1:6 are rater_info, 7-85 are candy items

## Notes: 
# 1. mutate(goes_trick_or_treating = as.logical(goes_trick_or_treating))
# coerces to NA, so need different approach to make T/F - not done yet
# 2. if processing additional_joy/despair ratings, keep in columns 98,99 
# in subsetting step, and process the additional ratings at this point
# in script, using df `x2015_subset_converted_all`

## step 3: make long format tidy data
# with one column for candy items [7-85], one column for rating
# expect 5630 x 85 df to become 
# (5630 raters * 79 items) x 8 = 444,770 x 8
x2015_tidy <- x2015_subset_converted %>% 
  pivot_longer(cols = -c(year, id, age, gender, country, goes_trick_or_treating),
               names_to = "candy_item",
               values_to = "rating")

dim(x2015_tidy) # 444,770 obs x 8 var - as expected
head(x2015_tidy, n = 20)
tail(x2015_tidy, n = 20)


# 2016 data: subset and make long format