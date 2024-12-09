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
cleaned_data <- raw_data %>% dplyr::select(data_id, language, form, item_kind, 
                                 category, uni_lemma, date_of_test,
                                 age, comprehension, production, 
                                 is_norming, child_id)

# Ensure `date_of_test` is in Date format
cleaned_data <- cleaned_data %>%
  mutate(date_of_test = as.Date(date_of_test))

# From EDA, observing the lack of data between 2004-2009, filter data to include only observations with date_of_test after 2009-01-01
cleaned_data <- cleaned_data %>% 
  filter(date_of_test > as.Date("2009-01-01"))

# Define a mapping of categories to broader groups
cleaned_data <- cleaned_data %>%
  mutate(broad_category = case_when(
    category %in% c("action_words", "helping_verbs") ~ "Verbs",
    category %in% c("connecting_words", "question_words", "quantifiers", "pronouns") ~ "Function Words",
    category %in% c("animals", "body_parts", "people") ~ "Living Things",
    category %in% c("clothing", "food_drink", "furniture_rooms", "household", "toys", "vehicles") ~ "Objects",
    category %in% c("games_routines") ~ "Activities",
    category %in% c("sounds") ~ "Sensory Words",
    category %in% c("descriptive_words", "time_words") ~ "Adjectives",
    category %in% c("locations", "places", "outside") ~ "Places",
    TRUE ~ "unknown"
  ))

# Combine production and comprehension into a new variable
cleaned_data <- cleaned_data %>%
  mutate(prod_comp_mean = (production + comprehension)/2) %>%
  drop_na(prod_comp_mean) 

# Create the high_vocabulary variable based on prod_comp_mean
cleaned_data <- cleaned_data %>%
  mutate(high_vocabulary = ifelse(prod_comp_mean > 300, 1, 0))

# Omit rows with NA values
cleaned_data <- cleaned_data %>% 
  na.omit()

# Look into first 6 rows of the finalized cleaned data
head(cleaned_data)

#### Save data ####
write_parquet(cleaned_data, sink = "data/02-analysis_data/cleaned_data.parquet")



