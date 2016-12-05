# Getting and Cleaning Data: Course Project

## Introduction
This repo contains the complete work for the `Getting and Cleaning Data` course project.

## Contents
- README.md
- CODEBOOK.md: `result.txt` column description
- run_analysis.R: Cleaning script
- result.txt: tidy data

## Script

The `run_analysis.R` script reads and cleans the data in the following order.

1. Loads the `reshape2` library: `melt` and `dcast` are used in the script.
2. Downloads the original data into `data.zip` if it is not present in the current working directory.
3. Unzips the `data.zip` file.
4. Reads the datasets.
  1. Reads the training data.
  2. Reads the test data.
  3. Reads the activities lables.
  4. Reads only the `mean` and `std` releated features list.
5. Merges the datasets.
6. Melts the data by `Subject` and `Activity`.
7. DCasts the data with the `mean` function.
8. Writes the tidy data into the `result.txt` file.


## Running
The script is run sourcing the file.
```R
source('~/<path-wd>/run_analysis.R')
```
