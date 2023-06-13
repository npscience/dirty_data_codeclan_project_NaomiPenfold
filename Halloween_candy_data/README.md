# Halloween Candy  

This is the README for the Halloween Candy data cleaning project, with information:
* [About the project](#About-the-project)
* [The structure of this repo](#Files) and the files within
* [Notes on the process](#Process-notes), i.e. what to expect within each script / notebook

## About the project

_initiate_

## Files

_initiate_

## Process notes

### Cleaning

2015:
* Renamed and reformatted variables about year and rater info, adding empty columns for gender and country (not present here)
* Recoded age data to retain 11 values when recoding as numeric data, the rest are not meaningful and ok to be coerced to NA
* Removed unwanted columns (not about candy items)
* Pivotted to longer format (candy_item, rating)
* Not yet dealt with additional ratings contained in columns x2015$98,99 --> 1000s additional ratings here, to include if time later
* Not yet looked for duplicates

