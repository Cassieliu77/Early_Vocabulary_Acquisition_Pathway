#### Preamble ####
# Purpose: Clean data from wordbankr package, retrieved from worbank website
# Author: Yongqi Liu
# Date: 13 Nov 2024 
# Contact: cassieliu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need have the raw dataset from wordbankr available
# Any other information needed? NA


#### Workspace setup ####
# Load necessary libraries
library(tidyverse)
library(wordbankr)
library(dplyr)
library(arrow)

#### Clean data ####
# Read the raw data parquet file
raw_data <- read_parquet("data/01-raw_data/raw_data.parquet")

# Select the needed columns
cleaned_data <- raw_data %>% select(data_id, item_id, language, form, item_kind, 
                                 category, uni_lemma, date_of_test,
                                 age, comprehension, production, 
                                 is_norming, child_id)

# Ensure `date_of_test` is in Date format
cleaned_data <- cleaned_data %>%
  mutate(date_of_test = as.Date(date_of_test))

# Filter data to include only rows with date_of_test after 2000-01-01
cleaned_data <- cleaned_data %>% 
  filter(date_of_test > as.Date("2000-01-01")) %>% 
  filter(production > 100) %>% filter(comprehension > 100)

# Define a mapping of categories to broader groups
cleaned_data <- cleaned_data %>%
  mutate(broad_category = case_when(
    category %in% c("action_words", "helping_verbs") ~ "verbs",
    category %in% c("connecting_words", "question_words", "quantifiers", "pronouns") ~ "function_words",
    category %in% c("animals", "body_parts", "clothing", "food_drink", "furniture_rooms", 
                    "games_routines", "household", "locations", "outside", "people", 
                    "places", "sounds", "toys", "vehicles") ~ "nouns",
    category %in% c("descriptive_words", "time_words") ~ "adjectives",
    TRUE ~ "unknown"))

# Omit rows with NA values
cleaned_data <- cleaned_data %>% 
  na.omit()

# Look into first 6 rows of the finalized cleaned data
head(cleaned_data)

#### Save data ####
write_parquet(cleaned_data, sink = "data/02-analysis_data/cleaned_data.parquet")



