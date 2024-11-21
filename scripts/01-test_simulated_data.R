#### Preamble ####
# Purpose: Test the structure and validity of the simulated wordbank dataset.
# Author: Yongqi Liu
# Date: 11 Nov 2024 
# Contact: cassieliu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` and `testthat` package must be installed and loaded
  # - simulated_data.csv must have been loaded
# Any other information needed? Make sure you are in the `Vocabulary_Learning_Pattern.Rproj`


#### Workspace setup ####
# Load necessary packages
library(tidyverse)
library(testthat)
library(here)

# Load the simulated data
simulated_data <- read_csv(here("data", "00-simulated_data", "simulated_data.csv"))

# Test if the data was successfully loaded
test_that("dataset was successfully loaded", {
  expect_true(exists("simulated_data"))
})


#### Test data ####

# Test 1: Test if the simulted dataset has the correct number of rows
test_that("dataset has 10000 rows", {
  expect_equal(nrow(simulated_data), 10000)
})

# Test 2: Test if the dataset has the correct number of columns
test_that("dataset has 14 columns", {
  expect_equal(ncol(simulated_data), 14)
})

# Test 3: Test if the 'language' column contains only valid languages
valid_languages <- c(
  "English (American)", "Spanish", "French", "German", "Chinese", "Japanese",
  "Korean", "Arabic", "Russian", "Hindi", "Portuguese", "Italian", 
  "Swedish", "Dutch", "Turkish", "Bengali", "Vietnamese", "Thai"
)
test_that("'language' column contains only valid languages", {
  expect_true(all(simulated_data$language %in% valid_languages))
})

# Test 4: Test if the 'category' column contains only valid categories
valid_categories <- c(
  "sounds", "animals", "vehicles", "toys", "food_drink", "clothing", 
  "body_parts", "furniture_rooms", "household", "outside", "people", 
  "games_routines", "action_words", "time_words", "descriptive_words", 
  "pronouns", "question_words", "locations", "quantifiers", "places", 
  "helping_verbs", "connecting_words"
)
test_that("'category' column contains only valid categories", {
  expect_true(all(simulated_data$category %in% valid_categories))
})

# Test 5: Test if there are no missing values in the dataset
test_that("dataset contains no missing values", {
  expect_true(all(!is.na(simulated_data)))
})

# Test 6: Test if 'age' falls within a valid range
test_that("'age' values are between 18 and 60", {
  expect_true(all(simulated_data$age >= 18 & simulated_data$age <= 60))
})

# Test 7: Test if 'comprehension' falls within a valid range
test_that("'comprehension' values are between 100 and 800", {
  expect_true(all(simulated_data$comprehension >= 100 & simulated_data$comprehension <= 800))
})

# Test 8: Test if 'production' falls within a valid range
test_that("'production' values are between 100 and 700", {
  expect_true(all(simulated_data$production >= 100 & simulated_data$production <= 700))
})

# Test 9: Test if 'date_of_test' is within a valid range
test_that("'date_of_test' is within the year 2010", {
  expect_true(all(simulated_data$date_of_test >= as.Date("2010-01-01") &
                    simulated_data$date_of_test <= as.Date("2010-12-31")))
})

# Test 10: Test if item_id values are unique for each data_id
test_that("item_id values are unique for each data_id", {
  expect_true(all(!duplicated(simulated_data[, c("data_id", "item_id")])))
})

# Test 11: Test if comprehension is greater than or equal to production
test_that("'comprehension' values are greater than or equal to 'production'", {
  expect_true(all(simulated_data$comprehension >= simulated_data$production))
})

#Test 13: Test if is_norming is only TRUE or FALSE
test_that("'is_norming' contains only TRUE or FALSE", {
  expect_true(all(simulated_data$is_norming %in% c(TRUE, FALSE)))
})

# Test 15: Test if date_of_test has no future dates
test_that("'date_of_test' contains no future dates", {
  expect_true(all(simulated_data$date_of_test <= Sys.Date()))
})

# Test 16: Test if broad_category has no unexpected categories
valid_broad_categories <- c("noun", "verb", "adjective", "other")
test_that("'broad_category' contains only valid categories", {
  expect_true(all(simulated_data$broad_category %in% valid_broad_categories))
})

# Test 17: Test if that the columns in the dataset (simulated_data) match the expected data types.
test_that("Column types are correct", {
  expect_is(simulated_data$data_id, "numeric")
  expect_is(simulated_data$item_id, "character")
  expect_is(simulated_data$language, "character")
  expect_is(simulated_data$form, "character")
  expect_is(simulated_data$item_kind, "character")
  expect_is(simulated_data$category, "character")
  expect_is(simulated_data$uni_lemma, "character")
  expect_is(simulated_data$broad_category, "character")
  expect_is(simulated_data$date_of_test, "Date")
  expect_is(simulated_data$age, "numeric") 
  expect_is(simulated_data$comprehension, "numeric")
  expect_is(simulated_data$production, "numeric")
  expect_is(simulated_data$is_norming, "logical")
  expect_is(simulated_data$child_id, "numeric") 
})

### Test Finished ###
# If all tests pass, print success message
cat("Tests all passed for simulated_data :)")