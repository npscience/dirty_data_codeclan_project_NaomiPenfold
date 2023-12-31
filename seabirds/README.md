# Seabird sightings

This is the README for the Seabirds data cleaning project, with information:
* [About the project](#About-the-project)
* [The structure of this repo](#Files) and the files within
* [Notes on the process](#Process-notes), i.e. what to expect within each script / notebook

## About the project

This repository was produced during the Codeclan "Dirty Data" project week, with the knitted analysis notebook (.html) as the final report.

This project uses data about seabirds provided by Codeclan. Note that this git repo ignores .xlsx and .csv files so the data files are not included in this public repository.

The seabirds data is about sightings of seabirds from ships. The raw data about the ships includes information about the location of the sighting, the weather conditions, and who sighted the birds. The raw data about the seabirds includes information about the number of seabirds counted in each sighting, as well as other details about the seabirds that were sighted.

From this data, we can find out which seabirds were sighted the most, in certain locations, and look up sightings of specific seabirds.

## Required packages

The code in this repo worked using the following installed packages and versions:

| Package | Version |
|----|----|
| here | "1.0.1" |
| janitor | "2.2.0" |
| readxl | "1.4.0" |
| forcats | "0.5.1" |
| stringr | "1.4.0" |
| dplyr | "1.1.2" |
| purrr | "0.3.4" |
| readr | "2.1.2" |
| tidyr | "1.2.0" |
| tibble | "3.2.1" |
| ggplot2 | "3.3.6" |
| tidyverse | "1.3.1" |


## Files

This repo contains:

* `raw_data`: raw data files about the seabirds and ships, as well as coding files that detail each variable and what their values could be.
* `data_cleaning_scripts`: `cleaning.R` produces cleaned csv files from the raw data, as per the process summarised below.
* `clean_data`: the final cleaned data to use in analysis is `bird_counts_cleaned.csv`. This folder also contains `bird_counts_raw.csv` which is an intermediary data file used in the `analysis.Rmd` to demonstrate the bird name cleaning steps.
* `documentation_and_analysis`: the `analysis.Rmd` notebook describes the tidying/cleaning steps taken (and decisions and assumptions made) and the data analysis itself.

## Process notes

To prepare the data for analysis, the cleaning.R script does the following

* 1. Joins the birds and ships data together (using a left join, to retain all seabird sightings with only the matching info for the ships from which they were sighted)
* 2. Selects only the required columns for the analyses and cleans the column names (into tidyverse style)
* 3. Writes this "tidy" data to csv: `clean_data/bird_counts_raw.csv`
* 4. Cleans the strings within the bird name columns (common_name, sci_name and species_abbreviation) to remove unnecessary information (about age and plummage)
* 5. Writes this "cleaned" data to csv: `clean_data/bird_counts_clean.csv`.

The `analysis.Rmd` details some initial exploration of the data and the cleaning steps taken (with decisions and assumptions made), before then analysing the data to answer the provided analysis questions. It requires the two .csv files generated by the `cleaning.R` script, which itself requires the raw data that is not provided in this public repository.

