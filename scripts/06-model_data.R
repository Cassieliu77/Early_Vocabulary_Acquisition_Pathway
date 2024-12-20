#### Preamble ####
# Purpose: Build the logistic regression model for the vocabulary size prediction
# Author: Yongqi Liu
# Date: 15 Nov 2024 
# Contact: cassieliu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure cleaned_data.parquet have been run, data is divided into test and training
# Any other information needed? Do the EDA to choose the appropriate model

#### Workspace setup ####
#install.packages("datawizard")
library(datawizard)
library(tidyverse)
library(rstanarm)
library(car)
library(arrow)
library(rsample)
library(modelsummary)

#### Read data ####
analysis_data<- read_parquet("data/02-analysis_data/cleaned_data.parquet")

### Model data ####
set.seed(853)

# Check and preprocess data
analysis_data <- analysis_data %>%
  mutate(
    age_scaled = as.numeric(scale(age)),  # Standardize age
    broad_category = factor(broad_category))

# Perform a split to get training and testing data
split <- initial_split(data=analysis_data, prop = 0.8)

# Create training and testing sets
analysis_data_train <- training(split)
analysis_data_test <- testing(split)

# Combine production and comprehension into a new variable
analysis_data_train <- analysis_data_train %>%
  mutate(prod_comp_mean = (production + comprehension)/2,  # Average of production and comprehension
    high_vocabulary = ifelse(prod_comp_mean > 300, 1, 0)  # Binary target variable
  ) %>%
  drop_na(prod_comp_mean)  # Drop rows where prod_comp_mean is NA

# Build the logistic regression model on the training dataset
logistic_model <- glm(
  high_vocabulary ~ age_scaled + is_norming + broad_category,
  data = analysis_data_train,
  family = binomial(link = "logit"))

# Print the summary of the model
modelsummary(logistic_model)

#### Save model ####
write_parquet(analysis_data_test, sink = "data/02-analysis_data/test_data.parquet")
write_parquet(analysis_data_train, sink = "data/02-analysis_data/train_data.parquet")
saveRDS(logistic_model, file = "models/logistic_model_last.rds")


