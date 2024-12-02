# Vocabulary Acquisition in Early Childhood

## Overview

This repository contains a study on how children acquire vocabulary during critical developmental stages (16–30 months), focusing on identifying key predictors and variations across lexical categories. Using data from the Wordbank database, the analysis employs logistic regression modeling to examine the relationship between age, norming status, lexical categories, and vocabulary levels.

## Key Features
- Developmental Focus: Explores vocabulary acquisition during the early childhood period, emphasizing critical milestones.
- Word Categories: Analyzes variations in comprehension and production across different word categories, such as Function Words, Sensory Words, and Adjectives.
- Predictive Modeling: Uses logistic regression to identify the influence of factors like age on achieving a vocabulary level during the given months.
- Data Source: Utilizes high-quality data from the [Wordbank](https://wordbank.stanford.edu/data) and the [MacArthur-Bates Communicative Development Inventories](https://mb-cdi.stanford.edu)


## File Structure

The repo is structured as:

-   `data/01-raw_data` contains the raw data as obtained from Wordbank R package.
-   `data/02-analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, datasheet, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, and clean data.

## Statement on LLM usage

Some aspects of the code and the paper were written with the help of the OpenAI ChatGPT 4o. The entire chat history is available in other/llm_usage/usage.txt.
