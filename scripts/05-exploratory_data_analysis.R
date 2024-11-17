#### Preamble ####
# Purpose: Downloads and saves the data from wordbankr package, retrieved from worbank website
# Author: Yongqi Liu
# Date: 13 Nov 2024 
# Contact: cassieliu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need
# Any other information needed? Make sure you are in the `xxxxx` rproj

#### Workspace setup ####
#Load Libraries
#install.packages("brms")
library(tidyverse)
library(wordbankr)
library(arrow)
library(ggplot2)
library(rstanarm)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/cleaned_data.parquet")


#### Data Distribution####

# Look at age distribution
ggplot(analysis_data, aes(x = age)) +
  geom_histogram(binwidth = 0.5, fill = "blue", alpha = 1) +
  labs(title = "Age Distribution", x = "Age (months)", y = "Count") +
  theme_minimal()

# Look at comprehension and production distribution

# Look at time











### Data Visualization ###
#Vocabulary size by age:Plot comprehension vs. production by age to see how children’s vocabulary develops over time.
ggplot(analysis_data, aes(x = age, y = comprehension, color = "Comprehension")) +
  geom_line() +
  geom_line(aes(y = production, color = "Production")) +
  labs(title = "Vocabulary Size by Age",
       x = "Age (months)",
       y = "Vocabulary Size",
       color = "Vocabulary Type") +
  theme_minimal()

#Comprehension and production summary by age:
analysis_data %>%
  group_by(age) %>%
  summarize(
    avg_comprehension = mean(comprehension, na.rm = TRUE),
    avg_production = mean(production, na.rm = TRUE)
  ) %>%
  ggplot(aes(x = age)) +
  geom_line(aes(y = avg_comprehension, color = "Comprehension")) +
  geom_line(aes(y = avg_production, color = "Production")) +
  labs(title = "Average Vocabulary Size by Age",
       x = "Age (months)",
       y = "Average Vocabulary Size",
       color = "Vocabulary Type") +
  theme_minimal()

#3.2 For analysis_data (Item-Level Data):
  ggplot(analysis_data, aes(x = comprehension, y = production)) +
  geom_bar(aes(color = category)) +
  labs(title = "Comprehension vs Production by Item",
       x = "Comprehension Score",
       y = "Production Score",
       color = "Item Category") +
  theme_minimal()

  analysis_data %>%
    group_by(category) %>%
    summarize(
      avg_comprehension = mean(comprehension, na.rm = TRUE),
      avg_production = mean(production, na.rm = TRUE)
    ) %>%
    ggplot(aes(x = category, y = avg_comprehension)) +
    geom_bar(stat = "identity", fill = "lightblue") +
    geom_bar(aes(y = avg_production), stat = "identity", fill = "lightgreen") +
    labs(title = "Comprehension and Production by Item Category",
         x = "Item Category",
         y = "Average Score",
         fill = "Vocabulary Type") +
    theme_minimal() +
    coord_flip() # To make the labels readable


  
  
  
  
  
  
  
### Model data ####
# Define the Bayesian regression model
bayesian_model <-stan_glm(
    formula = comprehension ~ age + category + lexical_category,  # Model formula
    data = analysis_data,                               # Dataset
    family = gaussian(),                                 # Gaussian distribution for continuous outcome
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 853,
    iter = 2000,                                        # Number of iterations
    chains = 4,                                         # Number of chains
    cores = 4)                                        # Use multiple core                     
  
# Print the summary of the Bayesian model
summary(bayesian_model)
  
# Visualize posterior distributions
plot(bayesian_model)
  
# Check posterior predictive checks
pp_check(bayesian_model)
  
#### Save model ####
saveRDS(first_model, file = "models/first_model.rds")


