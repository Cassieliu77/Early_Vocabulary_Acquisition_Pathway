#### Preamble ####
# Purpose: Run tests on cleaned data from wordbankr
# Author: Yongqi Liu
# Date: 13 Nov 2024 
# Contact: cassieliu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure cleaned_data.parquet have been loaded
# Any other information needed? Make sure you are in the `Vocabulary_Learning_Pattern.Rproj`


#### Workspace setup ####
# Load necessary packages
library(tidyverse)
library(testthat)
library(here)
library(arrow)

# Load the analysis data
analysis_data <- read_parquet(here("data", "02-analysis_data", "cleaned_data.parquet"))

# Test if the data was successfully loaded
test_that("dataset was successfully loaded", {
  expect_true(exists("analysis_data"))
})

#### Test data ####

# Test 1: Test if the dataset has the correct number of rows
test_that("dataset has the expected number of rows", {
  expect_true(nrow(analysis_data) > 0)  # Ensure it has rows
})

# Test 2: Test if the dataset has the correct number of columns
test_that("dataset has 14 columns", {
  expect_equal(ncol(analysis_data), 14)
})

# Test 3: Test if the 'language' column contains only valid languages
valid_languages <- c("English (American)")

test_that("'language' column contains only valid languages", {
  expect_true(all(analysis_data$language %in% valid_languages))
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
  expect_true(all(analysis_data$category %in% valid_categories))
})

# Test 5: Test if there are no missing values in the dataset
test_that("dataset contains no missing values", {
  expect_true(all(!is.na(analysis_data)))
})

# Test 6: Test if 'age' falls within a valid range
test_that("'age' values are between 16 and 60", {
  expect_true(all(analysis_data$age >= 16 & analysis_data$age <= 60))
})

# Test 7: Test if 'comprehension' falls within a valid range
test_that("'comprehension' values are between 100 and 1000", {
  expect_true(all(analysis_data$comprehension >= 100 & analysis_data$comprehension <= 1000))
})

# Test 8: Test if 'production' falls within a valid range
test_that("'production' values are between 100 and 1000", {
  expect_true(all(analysis_data$production >= 100 & analysis_data$production <= 1000))
})

# Test 9: Test if 'date_of_test' is within a valid range
test_that("'date_of_test' is after the year 2000", {
  expect_true(all(analysis_data$date_of_test >= as.Date("2000-01-01") &
                    analysis_data$date_of_test <= as.Date("2024-11-20")))
})

# Test 10: Test if item_id values are unique for each data_id
test_that("item_id values are unique for each data_id", {
  expect_true(all(!duplicated(analysis_data[, c("data_id", "item_id")])))
})

# Test 11: Test if comprehension is greater than or equal to production
test_that("'comprehension' values are greater than or equal to 'production'", {
  expect_true(all(analysis_data$comprehension >= analysis_data$production))
})

# Test 12: Test if is_norming is only TRUE or FALSE
test_that("'is_norming' contains only TRUE or FALSE", {
  expect_true(all(analysis_data$is_norming %in% c(TRUE, FALSE)))
})

# Test 13: Test if date_of_test has no future dates
test_that("'date_of_test' contains no future dates", {
  expect_true(all(analysis_data$date_of_test <= Sys.Date()))
})

# Test 14: Test if lexical_category has no unexpected categories
valid_lexical_categories <- c("nouns", "predicates", "function_words", "other")
test_that("'lexical_category' contains only valid categories", {
  expect_true(all(analysis_data$lexical_category %in% valid_lexical_categories))
})

# Test 15: Test if column types match expectations
test_that("Column types are correct", {
  expect_is(analysis_data$data_id, "numeric")
  expect_is(analysis_data$item_id, "character")
  expect_is(analysis_data$language, "character")
  expect_is(analysis_data$form, "character")
  expect_is(analysis_data$item_kind, "character")
  expect_is(analysis_data$category, "character")
  expect_is(analysis_data$uni_lemma, "character")
  expect_is(analysis_data$lexical_category, "character")
  expect_is(analysis_data$date_of_test, "Date")
  expect_is(analysis_data$age, "integer") 
  expect_is(analysis_data$comprehension, "integer")
  expect_is(analysis_data$production, "integer")
  expect_is(analysis_data$is_norming, "logical")
  expect_is(analysis_data$child_id, "integer") 
})

### Test Finished ###
# If all tests pass, print success message
cat("All tests passed for analysis_data :)")