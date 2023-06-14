# Script to clean raw data (excel spreadsheets) from 2015, 2016, 2017

# required libraries
library(tidyverse)
library(readxl)
library(janitor)

# load in raw data files
x2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx", sheet = "Form Responses 1")
x2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx", sheet = "Form Responses 1")
x2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx", sheet = "responses (2) (1).csv")

# Tidy 2015 data ---------

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
  mutate(country = rep(NA_character_, nrow(x2015_subset)), .after = gender) %>% 
  filter(!id == 1573) %>%  # remove 1 duplicate
  # reformat id as YYYYxxxx to make unique when years combined
  mutate(id = (year*10000)+id, .before = year)
# expect dim: 5629 observations x 85 variables
# cols 1:6 are rater_info, 7-85 are candy items

## Notes: 
# 1. mutate(goes_trick_or_treating = as.logical(goes_trick_or_treating))
# coerces to NA, so need different approach to make T/F - not done yet
# 2. if processing additional_joy/despair ratings, keep in columns 98,99 
# in subsetting step, and process the additional ratings at this point
# in script, using df `x2015_subset_converted_all`

## step 3: make long format tidy data
# with one column for candy items [7-85], one column for rating
# expect 5629 x 85 df to become 
# (5629 raters * 79 items) x 8 = 444,691 x 8
x2015_tidy <- x2015_subset_converted %>% 
  pivot_longer(cols = -c(year, id, age, gender, country, goes_trick_or_treating),
               names_to = "candy_item",
               values_to = "rating")

# step 4: write tidied 2015 data to new csv file
write_csv(x2015_subset_converted, "clean_data/2015_clean_wide.csv")
write_csv(x2015_tidy, "clean_data/2015_clean_long.csv")

# Tidy 2016 data ---------

## step 1: subset to remove unwanted columns
x2016_subset <- x2016 %>% 
  select(1:5,7:11,13,14,16:20,23:25,28:30,33:37,39:42,44:48,50:68,
         70:78,80:89,91:101,103,106) 
# not yet including 107:109 for additional ratings and comments
# 1259 obs x 88 var

## step 2: clean up included variables to produce required common df structure: 
# [1]id [2]year [3]age [4]gender [5]country 
# [6]goes_trick_or_treating [7]candy_item [8]rating
x2016_subset_converted <- x2016_subset %>% 
  # make an id column to retain unique identifier for each person
  mutate(id = c(1:nrow(x2016_subset)), .before = "Timestamp") %>% 
  # rename variables
  rename(year = "Timestamp",
         goes_trick_or_treating = "Are you going actually going trick or treating yourself?",
         gender = "Your gender:",
         age = "How old are you?",
         country = "Which country do you live in?"
  ) %>%
  # catch ages in country column before age is numerical
  mutate(age = if_else((str_detect(.$country, "^[0-9]+") & is.na(age)), country, age)) %>% 
  # change format of age and year data
  mutate(age = as.integer(age), # Note: this introduces NAs by coercion
         year = as.numeric(format(year, "%Y"))) %>% 
  mutate(id = (year*10000)+id, .before = year)
# outputs df: 1259 obs. x 89 var (1 more col than subset: id)

## step 3: make long format tidy data
# with one column for candy items 7:89, one column for rating
# expect 1259 x 90 df to become 
# (1259 raters * 83 items) x 8 = 104,497 x 8
x2016_tidy <- x2016_subset_converted %>% 
  pivot_longer(cols = -c(year, id, age, gender, country, goes_trick_or_treating),
               names_to = "candy_item",
               values_to = "rating")

dim(x2016_tidy) # 104,497 x 8

# step 4: write tidied 2016 data to new csv file
write_csv(x2016_subset_converted, "clean_data/2016_clean_wide.csv")
write_csv(x2016_tidy, "clean_data/2016_clean_long.csv")

# Tidy 2017 data ---------

## step 1: subset to remove unwanted columns
x2017_subset <- x2017 %>% 
  select(1:5,7:11,13,14,16:20,23:25,28:30,33:37,39:42,44:48,50:68,
         71:80,82:85,87:91,93:101,103,104,106,109) 
# not yet including 110:112 for additional ratings and comments
dim(x2017_subset)
# 2460 obs x 88 var

## step 2: clean up included variables to produce required common df structure: 
# [1]id [2]year [3]age [4]gender [5]country 
# [6]goes_trick_or_treating [7]candy_item [8]rating
x2017_subset_converted <- x2017_subset %>% 
  # rename variables
  rename(goes_trick_or_treating = "Q1: GOING OUT?",
         gender = "Q2: GENDER",
         age = "Q3: AGE",
         country = "Q4: COUNTRY") %>%
  # recode some specific age values before converting to numeric (see above)
  mutate(age = case_when(
    `Internal ID` == 90280448 ~ "69",
    `Internal ID` == 90280466 ~ "46",
    `Internal ID` == 90292907 ~ "58",
    .default = age)) %>%
  # catch ages in country column before age is numerical
  mutate(age = if_else((str_detect(.$country, "^[0-9]+") & is.na(age)), country, age)) %>% 
  # change format of age data
  mutate(age = as.integer(age)) %>% # Note: this introduces NAs by coercion
  # add a year column
  mutate(year = rep(2017, nrow(x2017_subset)), .before = goes_trick_or_treating) %>% 
  # make an id column to retain unique identifier for each person
  mutate(id = c(1:nrow(x2017_subset)), .before = year) %>% 
  mutate(id = (year*10000)+id, .before = year) %>% 
  # remove original id column
  select(-c(`Internal ID`))
# outputs df: 2460 obs. x 89 var (1 more col than subset: id)

## step 3: make long format tidy data
# with one column for candy items, one column for rating
# expect 2460 x 89 df to become 
# (2460 raters * 83 items) x 8 = 204,180 x 8
x2017_tidy <- x2017_subset_converted %>% 
  pivot_longer(cols = -c(year, id, age, gender, country, goes_trick_or_treating),
               names_to = "candy_item",
               values_to = "rating")

# step 4: write tidied 2017 data to new csv file
write_csv(x2017_subset_converted, "clean_data/2017_clean_wide.csv")
write_csv(x2017_tidy, "clean_data/2017_clean_long.csv")

# Join years data -------

# Bind rows
candy_ratings_allyears <- bind_rows(x2015_tidy, x2016_tidy, x2017_tidy)
write_csv(candy_ratings_allyears, "clean_data/candy_ratings_allyears.csv")

# Make candy item names consistent -----

candy_ratings_allyears_clean <- candy_ratings_allyears  %>% 
  # remove unwanted strings to standardise candy items
  mutate(candy_item = str_replace_all(candy_item, "^Q6\\ \\|\\ ", ""),
         candy_item = str_replace_all(candy_item, "^\\[", ""),
         candy_item = str_replace_all(candy_item, "\\]$", "")) %>% 
  # recode Mary Janes == anonymouse brown globs
  mutate(candy_item = case_when(
    candy_item %in% c("Anonymous brown globs that come in black and orange wrappers", "Anonymous brown globs that come in black and orange wrappers\t(a.k.a. Mary Janes)") ~ "Mary Janes",
    candy_item == "Bonkers" ~ "Bonkers (the candy)",
    candy_item == "Box’o’ Raisins" ~ "Box'o'Raisins",
    candy_item == "JoyJoy (Mit Iodine!)" ~ "JoyJoy (Mit Iodine)",
    candy_item == "Sweetums (a friend to diabetes)" ~ "Sweetums",
    candy_item == "Tolberone something or other" ~ "Toblerone",
    .default = candy_item)) %>% 
  # make new column with candy item by type (to collapse variants of same candy)
  mutate(candy_item_type = case_when(
    str_detect(.$candy_item, "marties") ~ "Smarties",
    str_detect(.$candy_item, "M\\&M") ~ "M&Ms",
    str_detect(.$candy_item, "Licorice") ~ "Licorice",
    str_detect(.$candy_item, "Jolly Rancher") ~ "Jolly Rancher",
    .default = candy_item
  ))

# Write cleaned data to new csv to load into analysis
write_csv(candy_ratings_allyears_clean, "clean_data/candy_ratings_allyears_clean.csv")
