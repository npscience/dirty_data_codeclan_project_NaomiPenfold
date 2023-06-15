# Halloween Candy  

This is the README for the Halloween Candy data cleaning project, with information:
* [About the project](#About-the-project)
* [The contents of this repo](#What's-in-this-repo?) and the files within
* [How to reproduce the output](#Requirements-to-reproduce-the-output)
* [Notes on the process](#Process-notes), i.e. what to expect within each script / notebook

## About the project

This repository was produced during the Codeclan "Dirty Data" project week, with the knitted analysis notebook (.html) as the [final report](documentation_and_analysis/analysis.Rnb.html).

The project was to clean and analyse data about candy preferences based on open data from surveying people around Halloween (including both those who go trick-or-treating and those who do not). The data includes information about the rater (such as age, gender and country (as specified by the rater), whether or not they go out trick or treating, their ratings of named items (in terms of JOY, MEH, and DESPAIR), as well as their answers to some additional questions. More information about the data is available [here](https://www.scq.ubc.ca/so-much-candy-data-seriously/). 

## What's in this repo?

This repo contains:

* `raw_data`: raw survey data from 2015, 2016 and 2017 in excel files.
* `data_cleaning_scripts`: `cleaning.R` produces cleaned csv files from the raw data, as per the process summarised below.
* `clean_data`: the final cleaned data to use in analysis is `candy_ratings_allyears_clean.csv`. This folder also contains `candy_ratings_allyears.csv` which is an intermediary data file used in the `analysis.Rmd` to demonstrate cleaning steps taken between tidy format data and the final cleaned dataset.
* `documentation_and_analysis`: the `analysis.Rmd` notebook describes the tidying/cleaning steps taken (and decisions and assumptions made), the data analysis, as well as some reflections on the project.

## Requirements to reproduce the output

The code in this repository worked using the following versions of packages (installed through library calls included within each script/notebook).

| Package | Version |
|----|----|
| here | "1.0.1" |
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

Note that this git repo ignores .xlsx and .csv files so the data files are not included in this public repository. To reproduce the analysis of this data, you need the following files and setup:

raw_data/ (3 files)
  - boing-boing-candy-2015.xlsx
  - boing-boing-candy-2016.xlsx
  - boing-boing-candy-2017.xlsx
clean_data/ (empty folder)

as well as the following files from this repo:

- cleaning.R
- analysis.Rmd

The raw data files can be downloaded from the [source](https://www.scq.ubc.ca/so-much-candy-data-seriously/) and should be renamed to match.

To reproduce the results:

* 1. Run the [cleaning.R](data_cleaning_scripts/cleaning.R) script to write the cleaned data files.
* 2. Run the analysis section of the [analysis.Rmd](analysis_and_documentation/analysis.Rmd/#analyse) to analyse the cleaned data.

## Process notes

The analysis.Rmd describes in detail how the cleaned data was prepared, and then performs analyses.

In brief, this entails:

In the cleaning.R script:

* 1. Tidying the data to rename columns (tidverse style) and pivot to longer format such that candy_items were in one column and ratings in another column (i.e. one row = one rating of one item by one rater in one year). To be able to distinguish unique raters again after this pivot, I added a uniqiue identifier column (id).
* 2. Joining together the data from all three years (2015-2017) by binding rows. (Note:I added a year column to each year's file first.) This produces a tall file! 
* 3. Cleaning up some of the data values within this tidy file, in particular in the country, age and candy item data.
* 4. Writing the output cleaned data to a new csv file in the clean_data/ folder in the project folder.

In the analysis.Rmd notebook:

* 5. Loading in the clean data (.csv) and making a subset with all the rater info (without ratings; a less tall file!)
* 6. Appending a column with a numeric value for each categorical rating (JOY = +1, MEH = 0, DESPAIR = -1) - this is to enable calculating popularity as the mean numeric rating value.
* 7. Analysing the data for information about the raters and ratings (as per analysis questions provided by Codeclan)
* 8. Finally, in the Reflections section, I create a vector of candy_items that are included in this cleaned data, which could be useful for improving the cleaning process here (and/or finding the columns to include if adding raw data from any other year's surveys form the same external project).

For this project, I have ignored any additional ratings data provided in free text answers to the Qs:

* "Please list any items not included above that give you JOY."
* "Please list any items not included above that give you DESPAIR."

There are additional candy items in these answers, which may change the results. In particular, I suspect there may be additional candy items (Kit Kat?) in the 2015 data that were not included in the survey questions that year but have been subsequently included in the 2016 and 2017 survey questions (and thus have their own named columns in these later years).

Other assumptions and decisions made during data cleaning and analysis have been documented within the analysis notebook.
