# Seabird sightings

This is the README for the Seabirds data cleaning project, with information:
* [About the project](#About-the-project)
* [The structure of this repo](#Files) and the files within
* [Notes on the process](#Process-notes), i.e. what to expect within each script / notebook

## About the project

_initiate_

## Files

_initiate_

## Process notes

_initiate_
1_exploration = initial exploration of data and planning of cleaning steps. 
* load in full raw data files from excel, inspect to understand contents
* understand analysis tasks and which columns this will require
* make a subset of raw data with the required data
* clean column names
* write subset to new csv as checkpoint (`bird_counts_raw.csv`) - at this point, no data changed (only column names)
* inspect subsetted data, make initial cleaning plan
Note: the code within this notebook is repeated in `cleaning.R` so you only need to run that cleaning script to generate the cleaned data from the raw data. It is included in this notebook to complement the documentation about my planning and decision making.
